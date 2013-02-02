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
    self = [self initEmpty];
    if (self) [self setUser:userId];
    return self;
}

- (id) initEmpty {
    self = [super initWithCommand:@"facebookLogin"];
    return self;
}

- (void) setUser:(NSString*) userId {
    [self setData:@{@"userId": userId}];
}

- (Boolean) isAuthCommand {
    return true;
}
@end
