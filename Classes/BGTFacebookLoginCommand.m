//
//  BGTFacebookLoginCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import "BGTFacebookLoginCommand.h"

@implementation BGTFacebookLoginCommand

- (id) initWithAccessToken:(NSString *)accessToken {
    self = [super initWithCommand:@"facebookLogin" andData:@{@"accessToken": accessToken}];
    return self;
}

- (Boolean) isAuthCommand {
    return true;
}
@end
