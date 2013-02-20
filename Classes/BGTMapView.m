//
//  BGTMapView.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 20.02.13.
//
//

#import "BGTMapView.h"

@implementation BGTMapView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    CGFloat statsHeight;
    if (frame.size.width / frame.size.height > 1) {
        // landscape mode
        statsHeight = 56;
    } else {
        // portrait mode
        statsHeight = 112;
    }
    [statistics setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, statsHeight)];
    [map setFrame:CGRectMake(frame.origin.x, frame.origin.x + statsHeight, frame.size.width, frame.size.height - statsHeight)];
    
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
