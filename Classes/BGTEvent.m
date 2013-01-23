//
//  BGTEvent.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 21.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTEvent.h"

@implementation BGTEvent

- (id) initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        eventId = [[json valueForKey:@"id"] intValue];
        name = [json valueForKey:@"title"];
        mapName = [json valueForKey:@"mapName"];
        
        NSDateFormatter* parser = [[NSDateFormatter alloc] init];
        // tell the parser the Z is literal (even though its actually a time zone specifier)
        [parser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        // and since the time zone information would be lost otherwise: fix the UTC timezone
        [parser setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        start = [parser dateFromString:[json valueForKey:@"start"]];
        
        subscriptions = [NSMutableDictionary dictionaryWithCapacity:5];
    }
    return self;
}

- (NSString *) getName {
    return name;
}

- (NSString *) getMapName {
    return mapName;
}

- (NSDate *) getStart {
    return start;
}

- (int) getId {
    return eventId;
}

- (void) addSubscriber:(BGTEventSubscriber *)subscriber forCategories:(NSArray *)categories {
    NSMutableArray* newCategories = [NSMutableArray arrayWithCapacity:5];
    for (NSString* category in categories) {
        NSMutableArray* catSub = [subscriptions objectForKey:category];
        if (!catSub) {
            catSub = [NSMutableArray arrayWithCapacity:5];
            [subscriptions setObject:catSub forKey:category];
            [newCategories addObject:category];
        }
        [catSub addObject:subscriber];        
    }

    if ([newCategories count] > 0) {
        BGTSubscribeUpdatesCommand* command = [[BGTSubscribeUpdatesCommand alloc] initWithEvent:self andCategories:newCategories];
        
        BGTSocket* socket = [BGTSocket getSharedInstance];
        [socket sendCommand:command];
    }
}

- (void) removeSubscriber:(BGTEventSubscriber *)subscriber {
    NSMutableArray* obsoleteCategories = [NSMutableArray arrayWithCapacity:5];
    for (NSString* category in subscriptions) {
        NSMutableArray* subscribers = [subscriptions objectForKey:category];
        if (![subscribers containsObject:subscriber]) continue;
        [subscribers removeObject:subscriber];
        if ([subscribers count] == 0) {
            [obsoleteCategories addObject:category];
        }
    }

    if ([obsoleteCategories count] > 0) {
        BGTUnsubscribeUpdatesCommand* command = [[BGTUnsubscribeUpdatesCommand alloc] initWithEvent:self andCategories: obsoleteCategories];
        [[BGTSocket getSharedInstance] sendCommand:command];
    }
    
    for (NSString* category in obsoleteCategories) {
        [subscriptions removeObjectForKey:category];
    }
}

@end
