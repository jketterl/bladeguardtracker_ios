//
//  BGTUser.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTUser.h"

@implementation BGTUser

NSMutableDictionary* users;

+ (BGTUser*) userWithId:(int)id {
    return [users objectForKey:[NSNumber numberWithInt:id]];
}

+ (void) addUser: (BGTUser*) user {
    if (users == nil) {
        users = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    [users setObject:user forKey:[NSNumber numberWithInt:[user getId]]];
}

- (id) initWithData:(NSDictionary*) data {
    self = [super init];
    if (self) {
        userId = [[data valueForKey:@"id"] intValue];
        
        NSString* teamName = [data objectForKey:@"team"];
        BGTTeam* teamObj = [BGTTeam teamForName:teamName];
        [self setTeam:teamObj];
        
        name = [data valueForKey:@"name"];
        
        [BGTUser addUser:self];
    }
    return self;
}

- (void) setTeam: (BGTTeam*) newTeam {
    team = newTeam;
}

- (BGTTeam*) getTeam {
    return team;
}

- (int) getId {
    return userId;
}

- (NSString*) getName {
    return name;
}
@end
