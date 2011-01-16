//
//  FlickrSearchTVC.h
//  hjlib
//
//  Created by markj on 1/5/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "FlickrSearch.h"
#import "HJObjManager.h"


@interface FlickrSearchTVC : UITableViewController <UISearchBarDelegate> {

	FlickrSearch* flickrSearch;
	//UISearchContentsController* searchController;
	
	HJObjManager* objMan;
}

@property (nonatomic, retain) FlickrSearch* flickrSearch;

@end
