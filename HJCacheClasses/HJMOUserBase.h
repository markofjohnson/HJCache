//
//  HJManagedObjBase.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJMOUser.h"
#import "HJMOHandler.h"

/*
 Just a simple base class for your own HJMOUser classes. For convienience only, 
 an HJMOUser doesn't have to extend HJMOUserBase
 */

@interface HJMOUserBase : NSObject <HJMOUser> {
	
	HJMOHandler* moHandler;
	id oid;
	NSURL* url;
	
}

@end
