//
//  HJObjManager.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net

#import <Foundation/Foundation.h>
#import "HJCircularBuffer.h"
#import "HJMOHandler.h"
#import "HJMOUser.h"
#import "HJMOPolicy.h"
#import "HJMOFileCache.h"


@interface HJObjManager : NSObject {

	HJMOPolicy* policy;
	HJCircularBuffer* loadingHandlers;
	HJCircularBuffer* memCache;
	HJMOHandler* flyweightManagedState;
	HJMOFileCache* fileCache;
}

@property (nonatomic, retain) HJMOPolicy* policy;
@property (nonatomic, retain) HJCircularBuffer* loadingHandlers;
@property (nonatomic, retain) HJCircularBuffer* memCache;
@property (nonatomic, retain) HJMOFileCache* fileCache;

-(HJObjManager*) initWithLoadingBufferSize:(int)loadingBufferSize memCacheSize:(int)memCacheSize;
-(HJObjManager*) init;

-(BOOL) manage:(id<HJMOUser>)user;
-(void) handlerFinishedDownloading:(HJMOHandler*)handler;

@end
