//
//  HJManagedState.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJMOHandler.h"
#import "HJMOUser.h"
#import "HJObjManager.h"
#import "HJMOFileCache.h"


@implementation HJMOHandler

@synthesize state;
@synthesize oid;
@synthesize url;
@synthesize urlConn;
@synthesize moData;
@synthesize moReadyDataFilename;
@synthesize moLoadingDataFile;
@synthesize managedObj;
@synthesize objManager;
@synthesize ownPolicy;


-(HJMOHandler*)initWithOid:(id)oid_ url:(NSURL*)url_  objManager:objManager_{
	[super init];
	state = stateNew;
	self.oid = oid_;
	self.url = url_ ;
	self.objManager = objManager_;
	if (oid==nil) { 
		self.oid = url_;
	}
	
	users = [[HJWeakMutableArray alloc] initWithCapacity:1]; //it can expand automatically.
	return self;
}

-(void)dealloc {
	//NSLog(@"dealloc %@",self);
	[urlConn cancel];
	[self clearLoadingState];
	[users release];
	[url release];
	[moReadyDataFilename release];
	//NSLog(@"managed Obj retain count before handler dealloc %i",[managedObj retainCount]);
	[managedObj release];
	[ownPolicy release];
	[oid release];
	[super dealloc];
}


-(BOOL) isEqual:(id)object {
	if (![object isKindOfClass:[HJMOHandler class]]) {
		return NO;
	}
	return [oid isEqual:[(HJMOHandler*)object oid]];
}

-(HJMOPolicy*)policy {
	if (ownPolicy) { 
		return ownPolicy;
	} else {
		return [objManager policy];
	}
}

-(void)addUser:(id<HJMOUser>)user {
	//check if already managing for this user (should not be if being used right)
	if (nil==[users findObject:user]) {
		[users addObject:user]; //did not already have user, so remember it (with a weak reference)
	} else {
		//can happen if users reused, and recycling code is lazy clearing old state, eg with UITableCellView
		//NSLog(@"HJMOHandler was already managing for user");
	}
	
	if (user.moHandler==nil) {
		//this is the normal case, so set the state
		user.moHandler=self;
	} else {
		if (user.moHandler==self) {
			//this is not what we expect, addUser has been called twice, but thats OK - do nothing
		} else {
			//user was pointing to another handler, this can happen when user is reused.
			//have to make sure that the old handler knows it should no longer manage for this user
			//otherwise it might send it callbacks, and it won't be able to become inactive (have no users)
			[user.moHandler removeUser:user];
			//now can assign the current state, which will also release the old one.
			user.moHandler=self;
		}
	}
}

-(void) deleteFileIfExistsAtPath:(NSString*)path {
	if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSError* e = nil;
		[[NSFileManager defaultManager] removeItemAtPath:path error:&e];
		if (e) {
			NSLog(@"HJMOHandler error deleting file %@",path);
		}
	}
}

-(void)clearLoadingState {
	self.urlConn=nil;
	[moLoadingDataFile closeFile];
	self.moLoadingDataFile = nil;
	self.moData = nil;
}

-(void)cancelLoading {
	if (state==stateLoading) {
		[urlConn cancel];
		[self clearLoadingState];
		state=stateNew;
	}
}

-(void)becameNotInUse {
	//TODO is there more policy decisions here?
	//[self cancelLoading]; //don't cancel loading, do that in dealloc. because object manager might be holding on to 
							//this handler in loadingHandlers to keep loading going
}

-(void)removeUser:(id<HJMOUser>)user {
	[users removeObject:user];
	[self retain]; //because the next line could dealloc self.
	user.moHandler = nil;
	if (![self isInUse]) {
		[self becameNotInUse];
	}
	[self autorelease];
}



-(BOOL)isInUse {
	return [users count]>0;
}

-(BOOL)isLoading {
	return urlConn!=nil;
}

-(BOOL)isReady {
	return managedObj!=nil;
}

-(void)touchFile:(NSString*)path {
	HJMOFileCache* fileCache = objManager.fileCache;
	if (fileCache==nil) { return; }
	NSTimeInterval ageLimit = fileCache.fileAgeLimit;
	if (ageLimit<=0) { return; }
	
	NSFileManager* fileMan = [NSFileManager defaultManager];

	NSError* e;
	NSDictionary* fsAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&e];		
	double ageSeconds = -1* [[fsAttributes fileModificationDate] timeIntervalSinceNow];

	if (ageSeconds>(ageLimit/4)) {
		//to save writes, file age modification date isn't changed on every access, only if 1/4 of age limit old.
		NSString *keyArray[1] = {NSFileModificationDate}; 
		id objectArray[1] = {[NSDate dateWithTimeIntervalSinceNow:0]};
		NSDictionary* attributes = [NSDictionary dictionaryWithObjects:objectArray forKeys:keyArray count:1];
		NSError* err;
		[fileMan setAttributes:attributes ofItemAtPath:path error:&err];
	}
}

-(void)activateNewHandlerForUser:(id<HJMOUser>)user {
	HJMOFileCache* fileCache = objManager.fileCache;
	if (fileCache) {
		//File caching is in use
		
		NSString* readyFile = [fileCache readyFilePathForOid:oid];
		
		if ([[NSFileManager defaultManager] fileExistsAtPath:readyFile]) {
			//mo is loaded as a file in file cache
			self.moReadyDataFilename = readyFile;
			if (self.policy.readsUpdateFileDate) {
				[self touchFile:readyFile];
			}
			state = stateLoaded;
			[self goFromLoadedToReady];
			return;
			
		} else {
			//not loaded yet, so load to file because file cache in use
			NSString* loadingFile = [fileCache loadingFilePathForOid:oid];
		
			BOOL ok = [[NSFileManager defaultManager] createFileAtPath:loadingFile contents:nil attributes:nil];
			if (!ok) {
				state = stateFailed;
				NSLog(@"HJMOHandler error creating loading file %@",loadingFile);
				loadingFile = nil;
				[self clearLoadingState]; 
				[self callbackFailedToUsers];
				return;
			} else {
				self.moLoadingDataFile = [NSFileHandle fileHandleForWritingAtPath:loadingFile];
			}
		}
	}
		
	//if file cache is in use temporary file name is prepared, either way now load from url
	[self startDownloadingFromURL];
}



-(void)activateHandlerForUser:(id<HJMOUser>)user {
	//stateNew, stateLoading, stateLoaded, stateReady, stateFailed 
	
	switch (state) {
			
		case stateNew:
			[self activateNewHandlerForUser:user];
			return;
			
		case stateLoading:
			//handler is still loading, have to wait for it to load, so nop.
			return;
			
		case stateLoaded:
			//for some reason it didn't go to ready when it was loaded, so try again now.
			[self goFromLoadedToReady];
			return;
			
		case stateReady:
			[user managedObjReady];
			return;
			
		case stateFailed:
			[user managedObjFailed];
			return;
			
		default:
			//not supposed to get here
			NSLog(@"HJMOHandler activateHandlerForUser error, no recognized state");
			break;
	}
}


-(void)startDownloadingFromURL {
	//NSLog(@"HJMOHandler starting download for %@",self);
	HJMOPolicy* policy = [self policy];
	NSURLRequest* request = [NSURLRequest requestWithURL:url 
										  cachePolicy:NSURLRequestReloadIgnoringLocalCacheData 
								          timeoutInterval:policy.urlTimeoutTime];
	self.urlConn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	[urlConn release];
	if (urlConn==nil) {
		NSLog(@"HJMOHandler nil URLConnection for %@",url);
		state=stateFailed;
	} else {
		state=stateLoading;
		//TODO if app is showing a network activity monitor in the status bar, here is where a call needs to be 
		// made to increment the number of active URLs
	}
}

-(void) goFromLoadedToReady {
	if ([users count]==0) {
		//can't go to stateReady because there's no user to do it. stay in stateLoaded.
		//this is not a bug, it can happen if the object has already been deleted before its content was
		//loaded over the net, eg because scrolled off the top of a table.
		//NSLog(@"HJMOHandler no user object to make it ready"); 
		return; 
	}
		
	self.managedObj=nil; //just to be sure there's not some old one around
	//pick _one_ and only one user to take mo from loaded to ready	
	id<HJMOUser> user = [users objectAtIndex:0];
	@try {
		[user changeManagedObjStateFromLoadedToReady];
		if (managedObj!=nil) {
			state = stateReady;  //because it worked
			[self callbackReadyToUsers];
		}
	} 
	@catch (id exception) {
		NSLog(@"%@",exception);
	}
	@finally {
		if (managedObj==nil) {
			state = stateFailed; //was still nil, so it didn't work.
			[self callbackFailedToUsers];
		}
	}
}

-(void) callbackReadyToUsers {
	for (id<HJMOUser> user in [users objectEnumerator]) {
		[user managedObjReady];
	}
}

-(void) callbackFailedToUsers {
	for (id<HJMOUser> user in [users objectEnumerator]) {
		[user managedObjFailed];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	if (state!=stateLoading) { return; }
	if (!moLoadingDataFile) {
		//loading direct to memory
		if (moData==nil) {
			self.moData = [NSMutableData dataWithCapacity:1024*10];
		}
		[moData appendData:data];
	} else {
		[moLoadingDataFile writeData:data];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	//NSLog(@"finishedLoading %@",self);
	state = stateLoaded;
	if (moLoadingDataFile) {
		//was downloading to file
		[moLoadingDataFile closeFile];
		self.moLoadingDataFile = nil;
		self.urlConn = nil;
		NSString* readyFilename = [self.objManager.fileCache loadingFinishedForOid:oid];
		if (readyFilename==nil) {
			state = stateFailed;
			[self callbackFailedToUsers]; 
			return;
		} else {
			self.moReadyDataFilename = readyFilename;
		}
	}
	//TODO if app is showing a network activity monitor in the status bar, here is where a call needs to be 
	// made to decrement the count of active URLs
	[self goFromLoadedToReady];
	[objManager handlerFinishedDownloading:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	state = stateFailed;
	NSLog(@"HJMOHandler URLConnection failed %@",error);
	//TODO if app is showing a network activity monitor in the status bar, here is where a call needs to be 
	// made to decrement the count of active URLs
	[self clearLoadingState]; 
	[self callbackFailedToUsers];
}


-(NSString*)description {
	return [NSString stringWithFormat:@"HJMOHandler %@ users:%i retains:%i",oid,[users count],[self retainCount]];
}


@end
