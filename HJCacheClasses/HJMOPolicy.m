//
//  HJManagedObjPolicy.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJMOPolicy.h"


@implementation HJMOPolicy

@synthesize urlTimeoutTime;
@synthesize readsUpdateFileDate;

//@synthesize loadToFile;
//@synthesize cacheInMemory;
//@synthesize asyncStartLoad;
//@synthesize asyncIsReadyIfCached;


+(HJMOPolicy*) smallImgFastScrollLRUCachePolicy {
	//this is the default policy settings.
	HJMOPolicy* policy = [[[HJMOPolicy alloc] init] autorelease];
	return policy;
}

/** default policy is good for small images, fast scrolling, async updates, LRU file cache */
-(HJMOPolicy*)init {
	[super init];
	self.urlTimeoutTime = 30;
	self.readsUpdateFileDate = YES;
	
	//self.loadToFile = YES;
	//self.cacheInMemory = YES;
	//self.asyncStartLoad = YES;
	//self.asyncIsReadyIfCached = YES;

	return self;
}


@end
