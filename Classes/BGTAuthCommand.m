//
//  BGTAuthCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import "BGTAuthCommand.h"

@implementation BGTAuthCommand

- (id) initWithUser:(NSString *)user andPassword:(NSString *)password {
    NSDictionary* data = @{@"user": user, @"pass": password};
    self = [super initWithCommand:@"auth" andData:data];
    return self;
}

- (Boolean) isAuthCommand {
    return true;
}

@end
