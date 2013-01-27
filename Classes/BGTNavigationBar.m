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
        NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [UIColor blackColor], UITextAttributeTextColor,
                                    [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset,
                                    [UIColor clearColor], UITextAttributeTextShadowColor,
                                    nil];
        self.titleTextAttributes = attributes;
        [[UIBarButtonItem appearance] setTitleTextAttributes:attributes forState:UIControlStateNormal];
    }
    return self;
}

- (void) layoutSubviews {
    CGRect frame = self.frame;
    CGFloat height = frame.size.height;
    
    CGRect iconFrame = CGRectMake(0, 0, height, height);
    [icon setFrame:iconFrame];
    
    [super layoutSubviews];
}

@end
