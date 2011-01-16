//
//  HJManagedObj.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import <Foundation/Foundation.h>

@class HJMOHandler;

/*
 HJMOUser is a protocol that is used to make a class works with a 'managed object' that can
 then be managed by the HJCache object manager. The HJMOUser contains a managed object and supplies
 information about it, and the managed object itself gets loaded, cached, shared, by the object
 manager.
 See the implementation of HJManagedImageV as a referance for writting your own HJMOUser classes.
 */

@protocol HJMOUser 

/*
 The object id for the managed object this HJMOUser is using. You can leave the oid nil, 
 and the url will be used as the oid. Some servers will tell you different urls for loading the
 same image as part of their server load balancing design. Eg if you get photos from facebook, 
 then facebook will send you different urls for the same photo id. By using oid you can 'de-dupe'
 those urls and prevent multiple network loads for images that are already cached.
 */
@property (nonatomic, retain) id oid;

/* 
 The url from which to load the managed object data
 */
@property (nonatomic, retain) NSURL* url;

/*
 The handler is an internal object to HJCache and its what ties the managed object user together
 with the managed object and the object manager. moHandler must be released in the dealloc
 method of any HJMOUser class. The handler has a weak reference to the HJMOUser, so
 dealloc will be called acording to normal Cocoa memory management conventions whether or not
 the managed object is being cached, etc. 
 */
@property (nonatomic, retain) HJMOHandler* moHandler;

/*
 This method is called by the object manager after data has been loaded from url or cache, 
 to create the managed object itself. Its this method that allows the HJCache to manage any 
 kind of object, eg UIImage, NSXMLDocument, etc, instead of just one specific class. 
 Note that this method is not called on every HJMOUser object, because if two different users 
 use the same managed object (same oid / url) then that managed object is only instanciated
 once and its then shared between the users. See the implementation of this method in 
 HJManagedImageV as a referance for writting your own HJMOUser classes.
 */
-(void) changeManagedObjStateFromLoadedToReady;

/*
 called when the object manager has made the managed object ready 
 */
-(void) managedObjReady;

/*
 called when the object manager has failed to make the managed object ready 
 */
-(void) managedObjFailed;

@end
