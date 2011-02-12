//
//  movieListCell.m
//  MobileEmergency
//
//  Created by Seung Woon Lee on 11. 2. 11..
//  Copyright 2011 Soongsil. All rights reserved.
//

#import "movieListCell.h"

@implementation movieListCell

@synthesize thumbNail;
@synthesize titleLabel;
@synthesize downloadButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state.
}

- (void)setMovieListData:(NSDictionary *)dic {
	[self.titleLabel setText:[dic objectForKey:@"title"]];
	NSString* imageURL =[dic objectForKey:@"thumbnail"];
	
	if ( [imageURL length] == 0)
		return;
	[self.thumbNail loadFromURL:[NSURL URLWithString:imageURL]];
}

- (void)dealloc {
    [super dealloc];
}


@end
