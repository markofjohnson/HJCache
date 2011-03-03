//
//  HJManagedImageV.h
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
 The managed image view is a UIView subclass that can be used just like any other view, 
 and it contains a UIImage object thats a managed object, and hence 
 can be cached, shared, and asynchronously loaded by the object manager. 
 So you can think of it like a UIImageView
 that has built in image object sharing, asynchronous loading, and caching.
 If you want to use HJCache for handling images (which is what its primarily designed for)
 you'll probably want to use this class or your own version of it.
 NB HJManagedImageV is an example of how to use HJCache, its not fully functional for all cases, 
 so don't be afraid to code your own version of it to suit your needs.
 */

@class HJManagedImageV;

@protocol HJManagedImageVDelegate
	-(void) managedImageSet:(HJManagedImageV*)mi;
	-(void) managedImageCancelled:(HJManagedImageV*)mi;
@end



@interface HJManagedImageV : UIView <HJMOUser> {
	
	id oid;
	NSURL* url;
	HJMOHandler* moHandler;
	
	UIImage* image;
	UIImageView* imageView;
	id callbackOnSetImage;
	id callbackOnCancel;
	BOOL isCancelled;
	UIActivityIndicatorView* loadingWheel;
	NSInvocation* onImageTap;
	int index; // optional; may be used to assign an ordering to a image.
	int modification;
}

@property int modification;
@property int index;
@property (nonatomic, retain) UIImage* image;
@property (nonatomic, retain) UIImageView* imageView;
@property (nonatomic, retain) UIActivityIndicatorView* loadingWheel;
@property (nonatomic, retain) id <HJManagedImageVDelegate> callbackOnSetImage;
@property (nonatomic, retain) id <HJManagedImageVDelegate> callbackOnCancel;

-(void) clear;
-(void) markCancelled;
-(UIImage*) modifyImage:(UIImage*)theImage modification:(int)mod;
-(void) setImage:(UIImage*)theImage modification:(int)mod;
-(void) showLoadingWheel;
-(void) setCallbackOnImageTap:(id)obj method:(SEL)m;

@end





