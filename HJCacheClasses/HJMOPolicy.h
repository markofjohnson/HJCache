//
//  HJManagedObjPolicy.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>

/*
 The policy has some settings for customizing how the object manger works. 
 Its optional, as the object manager has a default policy
 */

@interface HJMOPolicy : NSObject {

	NSTimeInterval urlTimeoutTime;
	
	//if YES, then when accessing a managed object that has a cahce file, the date on that
	//cache file is updated, so that the file cache can trim its size by deleting only
	//objects that have not been accessed recently
	BOOL readsUpdateFileDate;
	
	// TODO: make object manager use these parts of the policy
	//BOOL loadToFile;
	//BOOL cacheInMemory;
	//BOOL asyncStartLoad;
	//BOOL asyncIsReadyIfCached;
}

@property NSTimeInterval urlTimeoutTime;
@property BOOL readsUpdateFileDate;


//@property BOOL loadToFile;
//@property BOOL cacheInMemory;
//@property BOOL asyncStartLoad;
//@property BOOL asyncIsReadyIfCached;

+(HJMOPolicy*) smallImgFastScrollLRUCachePolicy;
	

@end
