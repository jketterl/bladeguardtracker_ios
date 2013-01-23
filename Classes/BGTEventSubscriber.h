//
//  BGTEventSubscriber.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 23.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTEvent.h"

// forward class declaration due to circular dependency between BGTEvent & BGTEventSubscriber
@class BGTEvent;

@protocol BGTEventSubscriber <NSObject>

- (void) receiveMessage: (NSString*) type withData: (NSDictionary*) data fromEvent: (BGTEvent*) event;

@end
