//
//  BGTUpdateRegistrationCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 30.01.13.
//
//

#import "BGTSocketCommand.h"

@interface BGTUpdateRegistrationCommand : BGTSocketCommand

- (id) initWithToken: (NSData*) token;

@end
