//
//  Content.h
//  hjlib
//
//  Created by markj on 1/25/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>




@interface Content : NSObject {

	NSString* contentID;
	NSString* text;
	NSURL* imgURL;
	NSString* imgID;

	
}

@property (nonatomic, retain) NSString* contentID;
@property (nonatomic, retain) NSString* text;
@property (nonatomic, retain) NSURL* imgURL;
@property (nonatomic, retain) NSString* imgID;


+(Content*) makeNextContent;


@end
