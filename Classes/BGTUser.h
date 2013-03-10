//
//  BGTUser.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTTeam.h"

@interface BGTUser : NSObject {
  @private
    BGTTeam* team;
    int userId;
    NSString* name;
}
+ (BGTUser*) userWithId:(int) id;
- (id) initWithData:(NSDictionary*) data;
- (BGTTeam*) getTeam;
- (int) getId;
- (NSString*) getName;

@end
