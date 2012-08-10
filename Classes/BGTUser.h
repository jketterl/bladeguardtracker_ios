//
//  BGTUser.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTTeam.h"

@interface BGTUser : NSObject
+ (BGTUser*) userWithId: (int) id;
- (void) setTeam: (BGTTeam*) team;
- (BGTTeam*) getTeam;

@end
