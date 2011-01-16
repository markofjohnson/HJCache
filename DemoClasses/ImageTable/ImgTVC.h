//
//  ImgTVC.h
//  hjlib
//
//  Created by markj on 1/25/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HJObjManager.h"


@interface ImgTVC : UITableViewController {

	NSMutableArray* content;
	HJObjManager* imgMan;
	
}

@property (nonatomic, retain) NSMutableArray* content;
@property (nonatomic, retain) HJObjManager* imgMan;

@end
