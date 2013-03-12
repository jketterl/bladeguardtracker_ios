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
    int lines;
    if (frame.size.width / frame.size.height < 7) {
        lines = 2;
    } else {
        lines = 1;
    }
    double itemsPerLine = ([self.subviews count] / lines);
    double width = frame.size.width / itemsPerLine;
    double height = frame.size.height / lines;
        
    for (int i = 0; i < lines; i++) {
        int start = i * itemsPerLine;
        for (int k = 0; k < itemsPerLine; k++) {
            UIView* view = [self.subviews objectAtIndex: start + k];
            [view setFrame:CGRectMake(frame.origin.x + k * width, frame.origin.y + i * height,width, height)];
        }
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
