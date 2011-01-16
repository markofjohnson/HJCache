//
//  HJManagedImageV.h
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net

#import <Foundation/Foundation.h>
#import "HJMOUser.h"
#import "HJMOHandler.h"


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
	int index; // optional; may be used to assign an ordering to a image when working with an album, e.g.
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





