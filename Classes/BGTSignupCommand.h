//
//  BGTRegisterCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import "BGTSocketCommand.h"

@interface BGTSignupCommand : BGTSocketCommand

- (id) initWIthUser:(NSString*) user andPass:(NSString*) pass;

@end
