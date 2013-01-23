//
//  BGTEvent.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 21.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGTEventSubscriber.h"

#import "BGTSubscribeUpdatesCommand.h"
#import "BGTUnsubscribeUpdatesCommand.h"
#import "BGTSocket.h"

// forward class declaration due to circular dependency between BGTEvent & BGTEventSubscriber
@class BGTEventSubscriber;

@interface BGTEvent : NSObject {
    @private int eventId;
    @private NSString* name;
    @private NSString* mapName;
    @private NSDate* start;
    
    @private NSMutableDictionary* subscriptions;
}

- (id) initWithJSON: (NSDictionary*) json;
- (NSString *) getName;
- (NSString *) getMapName;
- (NSDate *) getStart;
- (int) getId;

- (void) addSubscriber: (BGTEventSubscriber*) subscriber forCategories:(NSArray *) categories;
- (void) removeSubscriber: (BGTEventSubscriber*) subscriber;

@end
