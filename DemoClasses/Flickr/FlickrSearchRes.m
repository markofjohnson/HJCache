//
//  FlickrPhoto.m
//  hjlib
//
//  Created by markj on 1/5/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import "FlickrSearchRes.h"


@implementation FlickrSearchRes

+(NSString*)photoId:(NSDictionary*)searchRes {
	return  [searchRes objectForKey:@"id"];
}

+(NSString*)ownerId:(NSDictionary*)searchRes {
	return  [searchRes objectForKey:@"owner"];
}

+(NSString*)title:(NSDictionary*)searchRes {
	return  [searchRes objectForKey:@"title"];
}

+(NSString*)imageUrlBase:(NSDictionary*)searchRes {
	NSMutableString* url = [NSMutableString stringWithString:@"http://farm"];
	[url appendString:[searchRes objectForKey:@"farm"]];
	[url appendString:@".static.flickr.com/"];
	[url appendString:[searchRes objectForKey:@"server"]];
	[url appendString:@"/"];
	[url appendString:[searchRes objectForKey:@"id"]];
	[url appendString:@"_"];
	[url appendString:[searchRes objectForKey:@"secret"]];
	return url;
}

+(NSString*)image75pxUrl:(NSDictionary*)searchRes {
	return [NSString stringWithFormat:@"%@_s.jpg",[FlickrSearchRes imageUrlBase:searchRes]];
}

+(NSString*)image500pxUrl:(NSDictionary*)searchRes {
	return [NSString stringWithFormat:@"%@.jpg",[FlickrSearchRes imageUrlBase:searchRes]];
}


+(NSString*)ownerImageURL:(NSDictionary*)searchRes {
	NSMutableString* url = [NSMutableString stringWithString:@"http://farm"];
	[url appendString:[searchRes objectForKey:@"farm"]];
	[url appendString:@".static.flickr.com/"];
	[url appendString:[searchRes objectForKey:@"server"]];
	[url appendString:@"/"];
	[url appendString:[searchRes objectForKey:@"buddyicons"]];
	[url appendString:@"/"];
	[url appendString:[searchRes objectForKey:@"owner"]];
	[url appendString:@".jpg"];
	return url;
}



@end
