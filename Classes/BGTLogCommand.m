//
//  BGTLogCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 26.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTLogCommand.h"

@implementation BGTLogCommand

- (id) initWithLocation:(CLLocation *)location andEvent:(BGTEvent *)event {
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithFloat:location.coordinate.latitude], @"lat",
                          [NSNumber numberWithFloat:location.coordinate.longitude], @"lon",
                          [NSNumber numberWithInt:[event getId]], @"eventId", nil];
    if (location.speed >= 0) {
        [data setValue:[NSNumber numberWithFloat:location.speed] forKey:@"speed"];
    }
    self = [super initWithCommand:@"log" andData:data];
    return self;
}

@end
