//
//  BGTSubscribeEventsCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 23.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"
#import "BGTEvent.h"

@interface BGTSubscribeUpdatesCommand : BGTSocketCommand

- (id) initWithEvent:(BGTEvent *) event andCategories:(NSArray*) categories;

@end
