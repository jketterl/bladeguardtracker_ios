//
//  BGTUser.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTUser.h"

@implementation BGTUser {
    @private BGTTeam* team;
    @private int userId;
}
+ (BGTUser*) userWithId:(int)id {
    BGTUser* user = [[BGTUser alloc] init];
    user->userId = id;
    return user;
}
/*
- (BGTUser*) initWithTeam:(BGTTeam *)newTeam {
    self = [super init];
    if (self) team = newTeam;
    return self;
}
*/

- (void) setTeam: (BGTTeam*) newTeam {
    team = newTeam;
}

- (BGTTeam*) getTeam {
    return team;
}
@end
