//
//  BGTTeam.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTColorManipulation.h"

@interface BGTTeam : NSObject
+ (BGTTeam*) teamForName: (NSString*) name;
+ (BGTTeam*) teamForId: (int) id;
+ (BGTTeam*) anonymousTeam;
- (UIImage*) getImage;
@end
