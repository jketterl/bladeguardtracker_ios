//
//  BGTSubscribeEventsCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 23.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTSubscribeUpdatesCommand.h"

@implementation BGTSubscribeUpdatesCommand

- (id) initWithEvent:(BGTEvent *)event andCategories:(NSArray *)categories
{
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:[event getId]], @"eventId", categories, @"category", nil];
    self = [super initWithCommand:@"subscribeUpdates" andData:data];
    return self;
}

@end
