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
+ (BGTUserMarker*) markerWithUser: (BGTUser*) newUser {
    BGTUserMarker* marker = [[BGTUserMarker alloc] init];
    marker->user = newUser;
    return marker;
}

- (BGTUser*) getUser {
    return user;
}

@end
