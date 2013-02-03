//
//  BGTGPSUnavailableCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 03.02.13.
//
//

#import "BGTGPSUnavailableCommand.h"

@implementation BGTGPSUnavailableCommand

- (id) initWithEvent:(BGTEvent *)event {
    self = [super initWithCommand:@"gpsUnavailable" andData:@{@"eventId": [NSNumber numberWithInt: [event getId]]}];
    return self;
}

@end
