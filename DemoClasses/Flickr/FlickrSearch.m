//
//  FlickrDownload.m
//  Postcard
//
//  Created by markj on 2/16/09.
//  Copyright 2009 Mark Johnson. All rights reserved.
//

#import "FlickrSearch.h"


@implementation FlickrSearch

@synthesize searchResults;
@synthesize parser;


- (id) init {
	[super init];
	imageURLs = [NSMutableArray arrayWithCapacity:100];	
	[imageURLs retain];
	imageTitles = [NSMutableArray arrayWithCapacity:100];	
	[imageTitles retain];
	thumbnailViews = [NSMutableArray arrayWithCapacity:100];
	[thumbnailViews retain];
	
	return self;
}

- (void) dealloc {
	[imageURLs release];
	[imageTitles release];
	[thumbnailViews release];
	[parser release];
	[super dealloc];
	
}

- (int) numberOfImages {
	return [imageURLs count];
}

- (void) imageSearch:(NSString*)searchString {
	
	
	[imageURLs removeAllObjects];
	[imageTitles removeAllObjects];
	[thumbnailViews removeAllObjects];
	
	NSMutableString* urls = [NSMutableString stringWithCapacity:200];
	[urls appendString:@"http://api.flickr.com/services/rest/?"];
	[urls appendString:@"method=flickr.photos.search&"];
	[urls appendString:@"api_key=c4ee04d591412ab308c95ed9bb1b3c99&"];
	[urls appendString:@"license=7,4,2,1,5&"];
	[urls appendString:@"perPage=40&"];
	[urls appendString:@"media=photos&"];
	[urls appendString:@"text="];
	[urls appendString:[searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	 
	NSURL* url = [NSURL URLWithString:urls];
	//NSLog(@"URL: %@",url);
	
	//NSURLRequest* request = [NSURLRequest requestWithURL:url];
	//NSURLResponse* response;
	//NSError* error;
	//NSData* replyData = [NSURLConnection sendSynchronousRequest:request	returningResponse:&response error:&error];
	//NSString* replyString = [[NSString alloc] initWithBytes:[replyData bytes] length:[replyData length] encoding:NSUTF8StringEncoding];	
	//NSLog(@"reply: %@",replyString);
	//[replyString release];
	
	
	self.searchResults = [[[NSMutableArray alloc] initWithCapacity:100] autorelease];
	
	//Hmmm, the parser init line seems to be causing a small leak
	//http://stackoverflow.com/questions/1598928/nsxmlparser-leaking
	self.parser = [[[NSXMLParser alloc] initWithContentsOfURL:url] autorelease];
	
	[parser setDelegate:self];
	[parser parse];
}


- (void) appendToURLString:(NSMutableString*)url urlParam:(NSString*)param forKey:(NSString*)key fromDict:(NSDictionary*)dict {
	
	[url appendString:param];
	[url appendString:@"="];
	[url appendString:[dict objectForKey:key]];
	[url appendString:@"&"];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
										namespaceURI:(NSString *)namespaceURI 
										qualifiedName:(NSString *)qualifiedName 
										attributes:(NSDictionary *)attributeDict {

	if ([elementName isEqualToString:@"photo"]) {
		[searchResults addObject:attributeDict];
	}
		
		/*
		NSString* title=[attributeDict objectForKey:@"title"];
		NSString* owner=[attributeDict objectForKey:@"owner"];
		
		[imageTitles addObject:title];
		NSMutableString* url = [NSMutableString stringWithString:@"http://farm"];
		[url appendString:[attributeDict objectForKey:@"farm"]];
		[url appendString:@".static.flickr.com/"];
		[url appendString:[attributeDict objectForKey:@"server"]];
		[url appendString:@"/"];
		[url appendString:[attributeDict objectForKey:@"id"]];
		[url appendString:@"_"];
		[url appendString:[attributeDict objectForKey:@"secret"]];
		[imageURLs addObject:url];
		
		UIView* view = [[[UIView alloc] init] autorelease];
		view.tag=999;
		//CGRect rect = CGRectMake(0.0, 0.0, 320.0, 150);
		//view.bounds=rect;
		//view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		
		[thumbnailViews addObject:view];
	*/
		
}


- (NSURL*)thumbnailURLAtIndex:(int)index {
	NSMutableString* urls = [NSMutableString stringWithString:[imageURLs objectAtIndex:index]];
	[urls appendString:@"_s.jpg"];
	NSURL* url = [NSURL URLWithString:urls];
	return url;
}

- (NSURL*)imageURLAtIndex:(int)index {
	NSMutableString* urls = [NSMutableString stringWithString:[imageURLs objectAtIndex:index]];
	[urls appendString:@".jpg"];
	NSURL* url = [NSURL URLWithString:urls];
	return url;
}

- (NSData*)loadThumbnailDataAtIndex:(int)index {
	NSMutableString* urls = [NSMutableString stringWithString:[imageURLs objectAtIndex:index]];
	[urls appendString:@"_s.jpg"];
	NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urls]];
	return data;
}

- (UIImage*)loadThumbnailImageAtIndex:(int)index {
	return [UIImage imageWithData:[self loadThumbnailDataAtIndex:index]];
}
	
- (UIView*)thumbnailViewAtIndex:(int)index {
	return [thumbnailViews objectAtIndex:index];
}




@end
