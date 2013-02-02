//
//  BGTAuthCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import "BGTSocketCommand.h"

@interface BGTAuthCommand : BGTSocketCommand

- (id) initWithUser: (NSString*) user andPassword: (NSString*) password;

@end
