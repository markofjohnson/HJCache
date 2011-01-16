//
//  HJFiler.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>

/*
 Provides file caching for the object manager. Its able to trim its size so it 
 doesn't grow forever. See also HJBigFileCache.
 */

@interface HJMOFileCache : NSObject {

	NSString* rootPath;
	NSString* loadingPath;
	NSString* readyPath;
	NSString* countsPath;
	
	BOOL isCounting;
	BOOL isLRU;
	long fileCount;
	long long byteCount;
	
	long fileCountLimit;
	NSTimeInterval fileAgeLimit;
	NSThread* maintenanceThread;
}

@property long fileCount;
@property long long byteCount;
@property long fileCountLimit;
@property NSTimeInterval fileAgeLimit;
@property (nonatomic, retain) NSThread* maintenanceThread;

-(HJMOFileCache*)initWithRootPath:(NSString*)root;
-(HJMOFileCache*)initWithRootPath:(NSString*)root 
					   isCounting:(BOOL)isCounting 
				   fileCountLimit:(long)countLimit 
					 fileAgeLimit:(NSTimeInterval)ageLimit;

-(void)createCacheDirsIfNeeded;

-(NSString*)filenameForOid:(id)oid;
-(NSString*)readyFilePathForOid:(id)oid;
-(NSString*)loadingFilePathForOid:(id)oid;
-(NSString*)loadingFinishedForOid:(id)oid;
-(void)removeOid:(id)oid;

-(void) deleteAllFilesInDir:(NSString*)path;
-(void) emptyCache;
-(void) saveCounts;
-(void) loadCounts;
-(void)trimCache;
-(void)trimCacheUsingBackgroundThread;
-(void)trimCacheDir:(NSString*)cachePath;

@end
