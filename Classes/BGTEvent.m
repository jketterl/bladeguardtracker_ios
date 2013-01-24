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

- (void) addSubscriber:(id<BGTEventSubscriber>)subscriber forCategories:(NSArray *)categories {
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
        
        [socket addListener:self];
    }
}

- (void) removeSubscriber:(id<BGTEventSubscriber>)subscriber {
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
    
    if ([subscriptions count] == 0) {
        [[BGTSocket getSharedInstance] removeListener:self];
    }
}

- (void) receiveUpdate: (NSDictionary*) data {
    for (NSString* key in data) {
        NSArray* messages = [data objectForKey:key];
        NSArray* subscribers = [subscriptions objectForKey:key];
        if (subscribers == nil) continue;
        for (NSDictionary* message in messages) {
            NSNumber* eId = [message valueForKey:@"eventId"];
            // if (eId == nil) NSLog(@"WARN: event update without event ID");
            if ([eId intValue] != [self getId]) continue;
            for (id<BGTEventSubscriber> sub in subscribers) {
                [sub receiveMessage:key withData:message fromEvent:self];
            }
        }
    }
}

- (void) receiveStatus: (int) status {
    // this is not really interesting for us.
}

@end
