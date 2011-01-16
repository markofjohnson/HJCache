//
//  Content.m
//  hjlib
//
//  Created by markj on 1/25/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import "Content.h"


@implementation Content

@synthesize contentID, text, imgURL, imgID;

static int nextContentID = 0;


+(Content*) makeNextContent {
	
	nextContentID++;
	int imgNum = (rand()%3);
	//NSLog(@"imgNum %i",imgNum);
	
	Content* c = [[[Content alloc] init] autorelease];
	c.contentID = [NSString stringWithFormat:@"%i",nextContentID];
	c.text = [NSString stringWithFormat:@"Content %@ img %i",c.contentID, imgNum];
	c.imgID = [NSString stringWithFormat:@"%i",imgNum];

	NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.png",imgNum]];
	NSURL* url = [NSURL fileURLWithPath:path];				  
	
	c.imgURL = url;
	
	return c;
}



@end
