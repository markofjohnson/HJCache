//
//  HJFiler.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJMOFileCache.h"


@implementation HJMOFileCache

@synthesize fileCount;
@synthesize byteCount;
@synthesize fileAgeLimit;
@synthesize fileCountLimit;
@synthesize maintenanceThread;


-(HJMOFileCache*)initWithRootPath:(NSString*)root {
	[super init];
	isCounting = NO;
	fileCount = 0;
	byteCount = 0;
	rootPath = root;
	[rootPath retain];
	
	fileCountLimit = 0;
	fileAgeLimit = 0;
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:rootPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	
	loadingPath = [[NSString stringWithFormat:@"%@/loading/",rootPath] retain];
	readyPath = [[NSString stringWithFormat:@"%@/ready/",rootPath] retain];
	[self createCacheDirsIfNeeded];
	countsPath = [[NSString stringWithFormat:@"%@/counts.plist",rootPath] retain];

	//delete any half loaded files
	[self deleteAllFilesInDir:loadingPath];
	
	return self;
}

-(HJMOFileCache*)initWithRootPath:(NSString*)root 
					   isCounting:(BOOL)isCounting_ 
				   fileCountLimit:(long)countLimit
					 fileAgeLimit:(NSTimeInterval)ageLimit  {

	[self initWithRootPath:root];
	isCounting = isCounting_;
	fileCountLimit = countLimit;
	fileAgeLimit = ageLimit;

	if (isCounting) {
		[self loadCounts];
	}
	return self;
}


-(void)dealloc {
	[rootPath release];
	[loadingPath release];
	[readyPath release];
	[countsPath release];
	[maintenanceThread release];
	[super dealloc];
}


-(void)createCacheDirsIfNeeded {
	if (![[NSFileManager defaultManager] fileExistsAtPath:loadingPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:loadingPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
	if (![[NSFileManager defaultManager] fileExistsAtPath:readyPath]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:readyPath withIntermediateDirectories:YES attributes:nil error:nil];
	}
}


-(void) deleteAllFilesInDir:(NSString*)path {
	NSError* err=nil;
	NSArray* files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:&err];
	if (err!=nil) {
		return; 
	}
	for (NSString* file in files) {
		NSString* filepath = [NSString stringWithFormat:@"%@%@",path,file];
		[[NSFileManager defaultManager] removeItemAtPath:filepath error:&err];
	}
}

-(void) emptyCache {
	[self deleteAllFilesInDir:readyPath];
	[self deleteAllFilesInDir:loadingPath];
	self.fileCount=0;
	self.byteCount=0;
	if (isCounting) {
		[self saveCounts];
	}
}

-(NSString*)filenameForOid:(id)oid {
	NSString* oidStr = [NSString stringWithFormat:@"%@",oid];
	oidStr = [oidStr stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
	return oidStr;
}

-(NSString*)readyFilePathForOid:(id)oid {
	NSString* filename = [self filenameForOid:oid];
	NSString* path = [readyPath stringByAppendingString:filename];
	return path;
}

-(NSString*)loadingFilePathForOid:(id)oid {
	NSString* filename = [self filenameForOid:oid];
	NSString* path = [loadingPath stringByAppendingString:filename];
	return path;}

-(NSString*)loadingFinishedForOid:(id)oid {
	NSString* loadingFilename = [self loadingFilePathForOid:oid];
	NSString* readyFilename = [self readyFilePathForOid:oid];
	NSError* e=nil;
	[[NSFileManager defaultManager] moveItemAtPath:loadingFilename toPath:readyFilename error:&e];
	if (e) {
		NSLog(@"HJMOFileCache failed to move loading file to ready file %@",readyFilename);
		return nil;
	} else {
		if (isCounting) {
			NSError* e;
			NSDictionary* dict = [[NSFileManager defaultManager] attributesOfItemAtPath:readyFilename error:&e];
			NSNumber* size = [dict objectForKey:NSFileSize];
			fileCount++;
			byteCount = byteCount + size.unsignedIntegerValue;
			[self saveCounts];
		}
		return readyFilename;
	}
}

-(void)removeOid:(id)oid {
	NSError* err = nil;
	NSString* path = [self readyFilePathForOid:oid];
	NSError* e;
	NSDictionary* dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&e];	NSNumber* size = [dict objectForKey:NSFileSize];
	[[NSFileManager	defaultManager] removeItemAtPath:path error:&err];
	if (err==nil) {
		fileCount--;
		byteCount = byteCount - size.unsignedIntegerValue;
		[self saveCounts];
	} else {
		//NSLog(@"HJMOFileCache error deleting %@",path);
	}
}


-(void) saveCounts {
	NSMutableDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
								 [NSNumber numberWithLongLong:byteCount],@"bytes",
								 [NSNumber numberWithLong:fileCount],@"files",nil];
	[dict writeToFile:countsPath atomically:YES];
}

-(void) loadCounts {
	NSMutableDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:countsPath];
	NSNumber* files = [dict objectForKey:@"files"];
	NSNumber* bytes = [dict objectForKey:@"bytes"];
	if (files!=nil) {
		fileCount = [files longValue];
	} else {
		files = 0;
	}
	if (bytes!=nil) {
		byteCount = [bytes longLongValue];
	} else {
		byteCount = 0;
	}
}

int fileAgeCompareFunction(id obj1, id obj2, void *context) {
	NSNumber* age1 = [(NSArray*)obj1 objectAtIndex:0]; 
	NSNumber* age2 = [(NSArray*)obj2 objectAtIndex:0]; 
	return [age1 compare:age2];
}


-(void)trimCacheDir:(NSString*)cachePath {
	//limit number of files by deleting the oldest ones. 
	//creation date used to see age of file
	//modification date used to see staleness of file - how long since last used.
	
	NSLog(@"triming cache %@",cachePath);
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSString *file;
	NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:cachePath];
	
	NSMutableArray* fileAges = [NSMutableArray arrayWithCapacity:fileCountLimit]; //used to sort files by age
	int thisDirFileCount=0;
	int deletedCount=0;
	long deletedBytes=0;
	// this loop is the slow part, which is why this whole method is run on a separate thread.
	while ((file = [dirEnum nextObject])) {
		NSString* filename = [NSString stringWithFormat:@"%@%@",cachePath,file];
		NSError* e;
		NSDictionary* fsAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:filename error:&e];		
		double ageSeconds = -1* [[fsAttributes fileModificationDate] timeIntervalSinceNow];
		long filesize = [fsAttributes fileSize];
		if (ageSeconds>fileAgeLimit && fileAgeLimit>0) {
			//old files get deleted right away
			NSError* err=nil;
			[fileManager removeItemAtPath:filename error:&err];
			if (isCounting && err==nil) {
				deletedCount++;
				deletedBytes += filesize;
			}
		} else {
			//files that are not too old are going to be counted and sorted by age
			thisDirFileCount++;
			NSArray* fileAge; //a holder of filename, age, and size, for sorting names by file age
			if (isCounting) { 
				fileAge = [NSArray arrayWithObjects:[NSNumber numberWithDouble:ageSeconds],filename,[NSNumber numberWithLong:filesize],nil];
			} else {
				fileAge = [NSArray arrayWithObjects:[NSNumber numberWithDouble:ageSeconds],filename,nil];
			}
			[fileAges addObject:fileAge];
		}
	}
	
	if (thisDirFileCount >= fileCountLimit && fileCountLimit>0) {
		//thisDirFileCount is still over the limit (even if some old files were deleted) 
		//so now have to delete the oldest files. Behavoir of cache will be FIFO or LRU depending on cache policy readsUpdateFileDate
		[fileAges sortUsingFunction:fileAgeCompareFunction context:nil]; //sorted from oldest to youngest
		//for (NSArray* a in fileAges) {
		//	NSLog(@"%@ %@",[a objectAtIndex:0],[a objectAtIndex:1]);
		//}
		int index = [fileAges count]-1;
		//delete files until 20% under file count.
		while ((thisDirFileCount)>(fileCountLimit*0.8) && index>0) {
			NSError* err=nil;
			NSArray* fileAgeObj = [fileAges objectAtIndex:index];
			NSString* filename = [fileAgeObj objectAtIndex:1];
			//NSLog(@"deleting %@",filename);
			[fileManager removeItemAtPath:filename error:&err];
			if (err==nil) {
				thisDirFileCount--;
				if (isCounting) {
					NSNumber* filesize = [fileAgeObj objectAtIndex:2];
					deletedCount++;
					deletedBytes += [filesize longValue];
				}
			}
			index--;
		}
	}
	NSLog(@"cache file trimed %i files",deletedCount);
	if (isCounting) {
		fileCount -= deletedCount;
		byteCount -= deletedBytes;
		[self performSelectorOnMainThread:@selector(saveCounts) withObject:nil waitUntilDone:YES];
	}
}

-(void)trimCache {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	[self trimCacheDir:readyPath];
	[pool release];
}

-(void)trimCacheUsingBackgroundThread {
	self.maintenanceThread = [[[NSThread alloc] initWithTarget:self selector:@selector(trimCache) object:nil] autorelease];
	[maintenanceThread start];
}


@end
