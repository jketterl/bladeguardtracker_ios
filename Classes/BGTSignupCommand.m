//
//  BGTRegisterCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 02.02.13.
//
//

#import "BGTSignupCommand.h"

@implementation BGTSignupCommand

- (id) initWIthUser:(NSString *)user andPass:(NSString *)pass {
    self = [super initWithCommand:@"signup" andData:@{@"user":user, @"pass":pass}];
    return self;
}

@end
