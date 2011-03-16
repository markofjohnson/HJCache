//
//  HJObjManager.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJCircularBuffer.h"
#import "HJMOHandler.h"
#import "HJMOUser.h"
#import "HJMOPolicy.h"
#import "HJMOFileCache.h"


/* 
 HJObjManager is the object manager at the heart of HJCache. Normally you instanciate 
 one of these, assign it an HJMOFileCache, and then share it across the whole app. You can 
 however have as multiple HJMObjManager instances if you need more than one cache because
 you are dealing with different types of cached data.
 Note, HJObjManager should only be called from the main thread.
 */

@interface HJObjManager : NSObject {

	HJMOPolicy* policy;
	HJCircularBuffer* loadingHandlers;
	HJCircularBuffer* memCache;
	HJMOHandler* flyweightManagedState;
	HJMOFileCache* fileCache;
}

/*
 An options file cache for this object manager. If you want a file cache, just assign
 this right after instanciation.
 */
@property (nonatomic, retain) HJMOFileCache* fileCache;

/*
 Used to tweak the behavoir of this object manager. Its usually fine to just 
 use the default one the object manager creates for itself.
 */
@property (nonatomic, retain) HJMOPolicy* policy;

/*
 Internal state. These are the HJMOHandlers that are currently actively loading.
 */
@property (nonatomic, retain) HJCircularBuffer* loadingHandlers;

/*
 Internal state. This is the memory cache of managed objects
 */
@property (nonatomic, retain) HJCircularBuffer* memCache;


/*
 initilize the object manager with custom sizes for its internal buffer
 @param loadingBufferSize how many user objects can be loading at the same time, a FIFO buffer. 
    If you are using managed images in a scrolling table view, loadingBufferSize should be at least
	as big as the number of images on the screen at the same time.
 @param memCacheSize how many user objects are cached in memory
 */
-(HJObjManager*) initWithLoadingBufferSize:(int)loadingBufferSize memCacheSize:(int)memCacheSize;

-(HJObjManager*) init;

/* 
 If HJObjManager needs to be used to load a lot of managed objects at once, it's loading buffer needs to be big enough
 to hold them all. This method can be used to change loading buffer size to accomodate the application going into
 a different mode that needs to do this. It will cancel the loading of any objects that are loading at the time.
 */
-(void) resetLoadingBufferToSize:(int)loadingBufferSize;	

/*
 tells object manager to manage this user object, which will cause the object to 
 be loaded from in-memory cache, file cache, or its url.
 This method should only be called from the main thread of the app. If you need to call
 it from a different thread, use this: 
 [self.objectManager performSelectorOnMainThread:@selector(manage:) withObject:managedImage waitUntilDone:YES];
 */
-(BOOL) manage:(id<HJMOUser>)user;

/*
 called by HJMOHandler, which is internal to the object manager and HJMOUser
 */
-(void) addHandlerToMemCache:(HJMOHandler*)handler;

/*
 called by HJMOHandler, which is internal to the object manager and HJMOUser
 */
-(void) handlerFinishedDownloading:(HJMOHandler*)handler;

/*
 cancels any objects that are currently loading
 */
-(void) cancelLoadingObjects;

/*
 removed a single handler and its cached managed object
 */
-(void) removeFromHandlerFromCaches:(HJMOHandler*)handler;


@end
