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

@interface BGTEventList : NSObject <UITableViewDataSource> {
    @private NSMutableArray* events;
    @private UITableView* tableview;
}

- (id) initWithTableview:(UITableView *) tableview;
- (BGTEvent *) eventAtIndex: (int) index;
- (BGTEvent *) eventWithId: (int) eventId;
- (void) load: (NSInvocation*) onLoad;

@end
