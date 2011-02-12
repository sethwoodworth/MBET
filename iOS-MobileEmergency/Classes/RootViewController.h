//
//  RootViewController.h
//  MobileEmergency
//
//  Created by Seung Woon Lee on 11. 2. 11..
//  Copyright 2011 Soongsil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ASIHTTPRequest.h"
#import "movieListCell.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface RootViewController : UITableViewController < UITableViewDelegate, UITableViewDataSource, NSXMLParserDelegate >{
	movieListCell				*tableViewCell;
	NSXMLParser					*xParser;
	UIProgressView				*progressBar; 
	MPMoviePlayerViewController *playerController;
	UIButton					*selectedButton;
	NSTimer						*timer;

	NSMutableArray				*tableData;
	NSMutableDictionary			*aDictionary;
	NSString					*nextKey;
	
	BOOL						fininshed;
}

- (void)loadFromXML:(NSURL *)xmlUrl;
- (void)playTheMovie:(int)index;
- (void)downloadMovie:(int)index;
- (IBAction)onClickSubmitButton:(id)sender;

@property (nonatomic, retain) IBOutlet UITableViewCell *tableViewCell;

@end
