//
//  BGTFacebookLoginCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import "BGTFacebookLoginCommand.h"

@implementation BGTFacebookLoginCommand

- (id) initWithUserId:(NSString *)userId {
    self = [super initWithCommand:@"facebookLogin" andData:@{@"userId": userId}];
    return self;
}

@end
