//
//  BGTUserMarker.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTUserMarker.h"

@implementation BGTUserMarker {
    @private BGTUser* user;
}
- (id) initWithUser: (BGTUser*) newUser {
    self = [super init];
    if (self) {
        user = newUser;
        self.title = [newUser getName];
        self.subtitle = [[newUser getTeam] getName];
    }
    return self;
}

- (BGTUser*) getUser {
    return user;
}

@end
