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
	
	//A quick test of urls with spaces in them...
	// Note that this will work if loading an image from a url with a space in the filename, but not like this:
	// c.imgURL = [NSURL URLWithString:@"http://markj.net/stuff/filename with space.png"];
	// Only if you use the correct url escaping, which this will do for you:
	// c.imgURL = [[[NSURL alloc] initWithScheme:@"http" host:@"markj.net" path:@"/stuff/filename with space.png"] autorelease];
	
	return c;
}

-(void)dealloc {
	[contentID release];
	[text release];
	[imgURL release];
	//NSLog(@"imgID rt %i",[imgID retainCount]);
	[imgID release];
	[super dealloc];
}

@end
