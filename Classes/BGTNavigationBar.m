//
//  BGTNavigationBar.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 27.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTNavigationBar.h"

@implementation BGTNavigationBar

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        UIImage* image = [UIImage imageNamed:@"icon.png"];
        icon = [[UIImageView alloc] initWithImage:image];
        [super addSubview:icon];
    }
    return self;
}

- (void) layoutSubviews {
    CGRect frame = self.frame;
    CGFloat height = frame.size.height;
    
    CGRect iconFrame = CGRectMake(0, 0, height, height);
    [icon setFrame:iconFrame];
}

@end
