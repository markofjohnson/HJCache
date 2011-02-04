//
//  HJMOBigFileCache.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/


#import "HJMOBigFileCache.h"


NSString* HJMOBigFileCache_trimDirKey = @"HJMOBigFileCacheTrimDir";
NSString* HJMOBigFileCache_trimDateKey = @"HJMOBigFileCacheTrimDate";


@implementation HJMOBigFileCache

@synthesize lastTrimDate;
@synthesize lastTrimDirNum;

- (void) dealloc {
	[lastTrimDirNum release];
	[lastTrimDate release];	
	[super dealloc];
}

-(void)createCacheDirsIfNeeded {
	[super createCacheDirsIfNeeded];
	for (int i=0; i<=9; i++) {
		NSString* path = [NSString stringWithFormat:@"%@%i",readyPath,i];
		[[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
	}
}

-(NSString*)subdirForFilename:(NSString*)filename {
	unichar c1 = [filename characterAtIndex:[filename length]-1];
	unichar c2 = [filename characterAtIndex:[filename length]-2];
	int hashpath = (c1+c2)%10;
	return [NSString stringWithFormat:@"%i",hashpath];
}

-(NSString*)readyFilePathForOid:(id)oid {
	NSString* filename = [self filenameForOid:oid];
	NSString* subdir = [self subdirForFilename:filename];
	NSString* path;
	if (subdir==nil) {
		path = [readyPath stringByAppendingString:filename];
	} else {
		path = [NSString stringWithFormat:@"%@%@/%@",readyPath,subdir,filename];
	}
	return path;
}


-(void)updateLastTrimState {
	[[NSUserDefaults standardUserDefaults] setObject:self.lastTrimDirNum forKey:HJMOBigFileCache_trimDirKey];
	[[NSUserDefaults standardUserDefaults] setObject:self.lastTrimDate forKey:HJMOBigFileCache_trimDateKey];
	[[NSUserDefaults standardUserDefaults] synchronize];
}


/*
 This only trims 1/10th of the cache at a time, and does this no more than once every 1hrs.
 */
-(void)trimCache {
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	self.lastTrimDirNum = (NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:HJMOBigFileCache_trimDirKey];
	self.lastTrimDate = (NSDate*) [[NSUserDefaults standardUserDefaults] objectForKey:HJMOBigFileCache_trimDateKey];
	NSDate* now = [[[NSDate alloc] init] autorelease];
	
	if (lastTrimDate==nil || [now timeIntervalSinceDate:lastTrimDate]>60*60*1) {
		if (lastTrimDirNum==nil) {
			self.lastTrimDirNum = [NSNumber numberWithInt:-1];
		}
		int num = [lastTrimDirNum intValue];
		num++; 
		if (num>=10) { num=0; }
		NSString* nextTrimPath = [NSString stringWithFormat:@"%@%i/",readyPath,num];
		[self trimCacheDir:nextTrimPath];
		
		self.lastTrimDate = now;
		self.lastTrimDirNum = [NSNumber numberWithInt:num];
		[self updateLastTrimState];
	}
	[self performSelectorOnMainThread:@selector(updateLastTrimState) withObject:nil waitUntilDone:YES];
	
	[pool release];
}


@end
