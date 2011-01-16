//
//  HJManagedState.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>
#import "HJWeakMutableArray.h"
#import "HJMOUser.h"
@class HJObjManager;
@class HJMOPolicy;

/*
 HJMOHandler is an internal class, and should not be used directly 
 for most users of HJCache. The handler is responsible for sharing the managed object between
 different HJMOUsers, and loading it from url. If two HJMOUsers have the same oid (or url)
 then they share the same handler instance.
 */

@interface HJMOHandler : NSObject  {
	enum HJMOState { stateNew, stateLoading, stateLoaded, stateReady, stateFailed } state;
	id oid;
	BOOL isDataReady;
	NSURL* url;
	NSURLConnection* urlConn;
	NSMutableData* moData;
	NSString* moReadyDataFilename;
	NSFileHandle* moLoadingDataFile;
	id managedObj;
	HJWeakMutableArray* users;
	HJObjManager* objManager;
	HJMOPolicy* ownPolicy;
}

@property (readonly) enum HJMOState state;
@property (nonatomic, retain) id oid;
@property (nonatomic, retain) NSURL* url;
@property (nonatomic, retain) NSURLConnection* urlConn;
@property (nonatomic, retain) NSData* moData;
@property (nonatomic, retain) NSFileHandle* moLoadingDataFile;
@property (nonatomic, retain) NSString* moReadyDataFilename;
@property (nonatomic, retain) id managedObj;
@property (nonatomic, assign) HJObjManager* objManager;
@property (nonatomic, retain) HJMOPolicy* ownPolicy;


-(HJMOHandler*)initWithOid:(id)oid_ url:(NSURL*)url_  objManager:objManager_;


//in use means that it has one or more users
-(BOOL)isInUse;

//ready means that the managedObj is not nil and can be used by users. If not, then its unready
-(BOOL)isReady;

//loading means that its not ready yet, but it will become ready by itself because the url is or will start loading.
-(BOOL)isLoading;


-(void) addUser:(id<HJMOUser>)user;
-(void) removeUser:(id<HJMOUser>)mo;
-(void) activateHandlerForUser:(id<HJMOUser>)user ;
-(void) startDownloadingFromURL;
-(void) callbackReadyToUsers;
-(void) callbackFailedToUsers;
-(void) goFromLoadedToReady;
-(void) cancelLoading;
-(void) clearLoadingState;

@end



