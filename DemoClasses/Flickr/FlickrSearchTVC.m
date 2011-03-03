//
//  FlickrSearchTVC.m
//  hjlib
//
//  Created by markj on 1/5/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import "FlickrSearchTVC.h"
#import "FlickrSearchRes.h"
#import "HJObjManager.h"
#import "HJManagedImageV.h"


@implementation FlickrSearchTVC

@synthesize flickrSearch;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.flickrSearch = [[[FlickrSearch alloc] init] autorelease];
	self.tableView.rowHeight = 80;
	
	// Create the object manager
	objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:20];
	
	//if you are using for full screen images, you'll need a smaller memory cache than the defaults,
	//otherwise the cached images will get you out of memory quickly
	//objMan = [[HJObjManager alloc] initWithLoadingBufferSize:6 memCacheSize:1];
	
	// Create a file cache for the object manager to use
	// A real app might do this durring startup, allowing the object manager and cache to be shared by several screens
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/flickr/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	objMan.fileCache = fileCache;
	
	// Have the file cache trim itself down to a size & age limit, so it doesn't grow forever
	fileCache.fileCountLimit = 100;
	fileCache.fileAgeLimit = 60*60*24*7; //1 week
	[fileCache trimCacheUsingBackgroundThread];
	
}


- (void)dealloc {
	[objMan release];
    [super dealloc];
}



#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int n = [flickrSearch.searchResults count];
	return n;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
	HJManagedImageV* mi;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		
		//Create a managed image view and add it to the cell (layout is very naieve)
		mi = [[[HJManagedImageV alloc] initWithFrame:CGRectMake(243,2,75,75)] autorelease];
		mi.tag = 999;
		[cell addSubview:mi];
		
    } else {
		//Get a reference to the managed image view that was already in the recycled cell, and clear it
		mi = (HJManagedImageV*)[cell viewWithTag:999];
		[mi clear];
	}
    
	NSDictionary* searchRes = [flickrSearch.searchResults objectAtIndex:indexPath.row];
	NSString* title = [FlickrSearchRes title:searchRes];
	cell.textLabel.text = title;
	
	//set the URL that we want the managed image view to load
	mi.url = [NSURL URLWithString:[FlickrSearchRes image75pxUrl:searchRes]];

	//tell the object manager to manage the managed image view, 
	//this causes the cached image to display, or the image to be loaded, cached, and displayed
	[objMan manage:mi];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectRow");
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	[searchBar resignFirstResponder];
	[flickrSearch imageSearch:searchBar.text];
	//[searchBar.searchContentsController setActive:NO animated:YES];
	[self.tableView reloadData];
}




@end

