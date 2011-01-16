//
//  HJCacheAppDelegate.h
//  HJCache
//
//  Created by Mark Johnson on 1/15/11.
//  Copyright 2011 na. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HJCacheAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

