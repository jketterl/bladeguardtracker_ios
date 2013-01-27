//
//  weatherView.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 27.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTWeatherView.h"

@implementation BGTWeatherView

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addViews];
    }
    return self;
}

- (void) addViews {
    image = [[UIImageView alloc] init];
    label = [[UILabel alloc] init];
    [self addSubview:image];
    [self addSubview:label];
}

- (void) setValue:(NSNumber*)weather {
    NSString* weatherText;
    if (weather == (NSNumber*)[NSNull null]) {
        weatherText = @"No decision yet";
        [image setImage:nil];
    } else if ([weather intValue] == 1) {
        weatherText = @"Yes, we're rolling!";
        [image setImage:[UIImage imageNamed:@"ampel_gruen.png"]];
    } else {
        weatherText = @"Event cancelled";
        [image setImage:[UIImage imageNamed:@"ampel_rot.png"]];
    }
    label.text = NSLocalizedString(weatherText, nil);
    value = weather;
}

- (NSNumber*) value {
    return value;
}

- (void) layoutSubviews {
    CGRect imageFrame;
    CGRect labelFrame;
    if (self.value == (NSNumber*) [NSNull null]) {
        imageFrame = CGRectMake(0, 0, 0, 0);
        labelFrame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    } else {
        CGFloat height = self.frame.size.height;
        imageFrame = CGRectMake(0, 0, height, height);
        labelFrame = CGRectMake(height + 5, 0, self.frame.size.width - (height + 5), self.frame.size.height);
    }
    [image setFrame:imageFrame];
    [label setFrame:labelFrame];
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
