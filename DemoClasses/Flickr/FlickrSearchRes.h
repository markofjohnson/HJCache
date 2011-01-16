//
//  FlickrPhoto.h
//  hjlib
//
//  Created by markj on 1/5/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FlickrSearchRes : NSObject {
	
}

+(NSString*)photoId:(NSDictionary*)searchRes;
+(NSString*)ownerId:(NSDictionary*)searchRes;
+(NSString*)title:(NSDictionary*)searchRes;
+(NSString*)imageUrlBase:(NSDictionary*)searchRes;
+(NSString*)image75pxUrl:(NSDictionary*)searchRes;
+(NSString*)image500pxUrl:(NSDictionary*)searchRes;
+(NSString*)ownerImageURL:(NSDictionary*)searchRes;


@end
