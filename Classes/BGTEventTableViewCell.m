//
//  BGTEventTableViewCell.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 28.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTEventTableViewCell.h"

@implementation BGTEventTableViewCell

@synthesize weatherIcon;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        weatherIcon = [[UIImageView alloc] init];
        [weatherIcon setFrame:CGRectMake(0, 0, 20, 20)];
        [self addSubview:weatherIcon];
    }
    return self;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    CGFloat height = self.frame.size.height;
    [weatherIcon setFrame:CGRectMake(self.frame.size.width - (height + 15), height * .15, height * .7, height * .7)];
    [self.textLabel setFrame:CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y, self.frame.size.width - (height + 22), self.textLabel.frame.size.height)];
    [self.detailTextLabel setFrame:CGRectMake(self.detailTextLabel.frame.origin.x, self.detailTextLabel.frame.origin.y, self.frame.size.width - (height + 22), self.detailTextLabel.frame.size.height)];
}
@end
