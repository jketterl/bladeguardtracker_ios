//
//  BGTEventList.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 22.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGTSocket.h"
#import "BGTSocketCommand.h"
#import "BGTGetEventsCommand.h"
#import "BGTEvent.h"
#import "BGTEventTableViewCell.h"
#import "BGTEventListListener.h"

@interface BGTEventList : NSObject <UITableViewDataSource> {
    @private NSMutableArray* events;
    @private NSMutableArray* listeners;
}

+ (BGTEventList *) getSharedInstance;

- (BGTEvent *) eventAtIndex: (int) index;
- (BGTEvent *) eventWithId: (int) eventId;
- (void) load;
- (void) addListener:(id<BGTEventListListener>) listener;
- (void) removeListener:(id<BGTEventListListener>) listener;

@end
