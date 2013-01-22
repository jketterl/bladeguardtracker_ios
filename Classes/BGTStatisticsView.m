//
//  BGTStatisticsView.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 22.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTStatisticsView.h"

@implementation BGTStatisticsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFrame:(CGRect)frame{
    double offset = 0;
    double width = frame.size.width / [self.subviews count];
    for (UIView* view in self.subviews) {
        CGRect subFrame = CGRectMake(round(offset), 0, round(width), frame.size.height);
        [view setFrame:subFrame];
        offset += width;
    }
    [super setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
