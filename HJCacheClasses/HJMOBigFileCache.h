//
//  HJMOBigFileCache.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJMOFileCache.h"

/*
 HJBigFileCache is more scalable for very large caches. When the cache gets very
 large, then the trim time gets big because trimming the size of the cache requires
 scanning through all of its files and checking their age and size. HJBigFileCache
 divides that probem into 10 by trimming 1/10th of the cache each day in a 10 day cycle.
 */

@interface HJMOBigFileCache : HJMOFileCache {

	NSNumber* lastTrimDirNum;
	NSDate* lastTrimDate;
}

@property (retain) NSNumber* lastTrimDirNum;
@property (retain) NSDate* lastTrimDate;

@end
