//
//  BGTGPSUnavailableCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 03.02.13.
//
//

#import "BGTSocketCommand.h"
#import "BGTEvent.h"

@interface BGTGPSUnavailableCommand : BGTSocketCommand

- (id) initWithEvent: (BGTEvent*) event;

@end
