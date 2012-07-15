//
//  BGTSocketCommand.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"

@implementation BGTSocketCommand

- (id) initwithCommand:(NSString*) newCommand {
    self = [self init];
    if (self) command = newCommand;
    return self;
}
- (id) initwithCommand:(NSString *)newCommand andData:(NSObject *) newData {
    self = [self initwithCommand:newCommand];
    if (self) data = newData;
    return self;
}
- (NSString*) getJson {
    NSMutableDictionary* json = [NSMutableDictionary dictionaryWithCapacity:2];
    [json setValue:command forKey:@"command"];
    if (data != nil) [json setValue:data forKey:@"data"];
    return [json JSONRepresentation];
}
@end
