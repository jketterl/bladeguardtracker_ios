//
//  BGTTeam.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BGTColorManipulation.h"

@interface BGTTeam : NSObject {
  @private
    NSString* name;
    int teamId;
    UIImage* image;
}
+ (BGTTeam*) teamForName: (NSString*) name;
+ (BGTTeam*) teamForId: (int) id;
+ (BGTTeam*) anonymousTeam;
- (id) initWithId:(int) id;
- (UIImage*) getImage;
- (void) setName: (NSString*) name;
- (NSString*) getName;
@end
