//
//  ImgTVC.m
//  hjlib
//
//  Created by markj on 1/25/10.
//  Copyright 2010 Mark Johnson. All rights reserved.
//

#import "ImgTVC.h"
#import "Content.h"
#import "ImgCell.h"
#import "HJMOFileCache.h"


@implementation ImgTVC

@synthesize content, imgMan;



-(void) viewDidLoad {
	self.imgMan = [[[HJObjManager alloc] init] autorelease];
	NSString* cacheDirectory = [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/imgcache/imgtable/"] ;
	HJMOFileCache* fileCache = [[[HJMOFileCache alloc] initWithRootPath:cacheDirectory] autorelease];
	self.imgMan.fileCache = fileCache;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	int rows = 20;
	
	if (self.content==nil) {
		self.content = [NSMutableArray arrayWithCapacity:rows];
		for (int i=0; i<rows; i++) {
			[content addObject:[Content makeNextContent]];
		}	
	}
	
    return rows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellType = @"ImgCell";
    ImgCell *cell = (ImgCell*)[tableView dequeueReusableCellWithIdentifier:cellType];
    if (cell == nil) {
        //cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellType owner:nil options:nil];
        cell = (ImgCell*)[nib objectAtIndex:0];
    }
	
    
    // Set up the cell...
	Content* c = (Content*)[self.content objectAtIndex:indexPath.row];
	
	cell.text1.text = c.text;
	[cell.img clear];
	cell.img.url = c.imgURL;
	cell.img.oid = c.imgID;
	[self.imgMan manage:cell.img];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView didSelectRowAtIndexPath row %i",indexPath.row);
}




- (void)dealloc {
	self.content = nil;
	self.imgMan = nil;
    [super dealloc];
}


@end

