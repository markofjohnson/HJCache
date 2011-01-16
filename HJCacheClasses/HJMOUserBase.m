//
//  HJManagedObjBase.m
//  hjlib
//
//  Copyright Hunter and Johnson 2009, 2010, 2011
//  HJCache may be used freely in any iOS or Mac application free or commercial.
//  May be redistributed as source code only if all the original files are included.
//  See http://www.markj.net/hjcache-iphone-image-cache/

#import "HJMOUserBase.h"


@implementation HJMOUserBase

@synthesize moHandler;
@synthesize oid;
@synthesize url;


-(void) dealloc {
	[moHandler removeUser:self];
	[moHandler release];
	[oid release];
	[url release];
	[super dealloc];
}

-(void) changeManagedObjStateFromLoadedToReady {
	
}

-(void) managedObjReady {
	
}

-(void) managedObjFailed {
	
}



@end
