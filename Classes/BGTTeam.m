//
//  BGTTeam.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTTeam.h"

@implementation BGTTeam {
    @private int teamId;
    @private UIImage* image;
}
static NSMutableArray* teams;
static BGTTeam* anonymousTeam;
static NSArray* teamColors;
               
+ (BGTTeam*) teamForName: (NSString*) name {
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+)" options:0 error:&error];
    NSArray* matches = [regex matchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if ([matches count] > 0) {
        NSTextCheckingResult* match = [matches objectAtIndex:0];
        int teamId = [[name substringWithRange:[match range]] intValue];
        return [self teamForId:teamId];
    }
    return [self anonymousTeam];
}

+ (BGTTeam*) teamForId: (int) id {
    if (teams == NULL) teams = [NSMutableArray arrayWithCapacity:10];
    while (id > [teams count]) {
        BGTTeam* team = [[BGTTeam alloc] init];
        team->teamId = [teams count] + 1;
        [teams addObject:team];
    }
    return [teams objectAtIndex:id - 1];
}
+ (BGTTeam*) anonymousTeam {
    if (anonymousTeam == nil) {
        anonymousTeam = [[BGTTeam alloc] init];
    }
    return anonymousTeam;
}
- (UIImage*) getImage {
    if (teamColors == nil) {
        teamColors = [NSArray arrayWithObjects:
                      // Team 1 gets a nice red
                      [BGTColorManipulation manipulationWithHue:15 Saturation:2 Value:1],
                      // Team 2 gets the original png color, kind of orange
                      [BGTColorManipulation manipulationWithHue:0 Saturation:1 Value:1],
                      // Team 3 gets deep purple
                      [BGTColorManipulation manipulationWithHue:109 Saturation:1.4 Value:.5],
                      // Team 4 is bright blue
                      [BGTColorManipulation manipulationWithHue:165 Saturation:1 Value:1.1],
                      // Team 5 is bright green
                      [BGTColorManipulation manipulationWithHue:-106 Saturation:1 Value:1.1],
                      // Team 6 wishes to be blue
                      [BGTColorManipulation manipulationWithHue:170 Saturation:1.6 Value:.6],
                      // Team 7 is yellow
                      [BGTColorManipulation manipulationWithHue:-37 Saturation:2.2 Value:1],
                      nil];
    }
    if (image == nil) {
        if (teamId <= 0 || [teamColors count] < teamId) {
            image = [UIImage imageNamed:@"pin.png"];
        } else {
            BGTColorManipulation* man = [teamColors objectAtIndex:teamId - 1];
            image = [man manipulateImage:[UIImage imageNamed:@"pin_common.png"]];
        }
    }
    return image;
}

@end
