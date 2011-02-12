//
//  movieListCell.h
//  MobileEmergency
//
//  Created by Seung Woon Lee on 11. 2. 11..
//  Copyright 2011 Soongsil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+Cached.h"


@interface movieListCell : UITableViewCell {
	UIImageView				*thumbNail;
	UILabel					*titleLabel;
	UIButton				*downloadButton;
}

@property (retain, nonatomic) IBOutlet UIImageView		*thumbNail;
@property (retain, nonatomic) IBOutlet UILabel			*titleLabel;
@property (retain, nonatomic) IBOutlet UIButton			*downloadButton;

- (void)setMovieListData:(NSDictionary *)dic;
@end
