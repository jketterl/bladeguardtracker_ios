//
//  BGTEvent.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 21.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BGTSocket.h"
#import "BGTSocketEventListener.h"
#import "BGTEventSubscriber.h"
#import "BGTSubscribeUpdatesCommand.h"
#import "BGTUnsubscribeUpdatesCommand.h"

// forward class declaration due to circular dependency between BGTEvent & BGTEventSubscriber
@protocol BGTEventSubscriber;

@interface BGTEvent : NSObject <BGTSocketEventListener> {
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

- (void) addSubscriber: (id<BGTEventSubscriber>) subscriber forCategories:(NSArray *) categories;
- (void) removeSubscriber: (id<BGTEventSubscriber>) subscriber;

@end
