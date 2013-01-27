//
//  BGTQuitCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 26.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTQuitCommand.h"

@implementation BGTQuitCommand

- (id) initWithEvent:(BGTEvent *)event {
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[event getId]], @"eventId", nil];
    self = [super initWithCommand:@"quit" andData:data];
    return self;
}

@end
