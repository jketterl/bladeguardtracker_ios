//
//  BGTLogCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 26.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"
#import <CoreLocation/CoreLocation.h>
#import "BGTEvent.h"

@interface BGTLogCommand : BGTSocketCommand
- (id) initWithLocation: (CLLocation*) location andEvent:(BGTEvent*) event;
@end
