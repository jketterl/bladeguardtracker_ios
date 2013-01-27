//
//  BGTQuitCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 26.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"
#import "BGTEvent.h"

@interface BGTQuitCommand : BGTSocketCommand
- (id) initWithEvent:(BGTEvent*) event;
@end
