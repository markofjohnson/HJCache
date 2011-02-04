//
//  RootViewController.m
//  HJCache
//
//  Created by Mark Johnson on 1/15/11.
//  Copyright 2011 na. All rights reserved.
//

#import "RootViewController.h"
#import "FlickrSearchTVC.h"
#import "ImgTVC.h"


@implementation RootViewController



#pragma mark -
#pragma mark Table view data source


// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.row==0) {
		cell.textLabel.text = @"Flickr Search Demo";
	} else if (indexPath.row==1) {
		cell.textLabel.text = @"Shared Images Demo";
	}

    return cell;
}





#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row==0) {
		// this simple demo shows managed images being used to load, cache, and show images from Flickr
		FlickrSearchTVC* flickrTVC = [[[FlickrSearchTVC alloc] initWithNibName:@"FlickrSearchTVC"
																		bundle:nil] autorelease];
		[self.navigationController pushViewController:flickrTVC animated:YES];

		
	} else if (indexPath.row==1) {
		// this simple demo shows how managed images can be shared and reused in the same table
		ImgTVC* imgTVC = [[[ImgTVC alloc] initWithNibName:@"ImgTVC" bundle:nil] autorelease];
		[self.navigationController pushViewController:imgTVC animated:YES];
	}
	
}



- (void)dealloc {
    [super dealloc];
}


@end

