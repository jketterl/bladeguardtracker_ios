//
//  BGTSocketCommand.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"

@implementation BGTSocketCommand
@synthesize command;
@synthesize data;

- (id) initwithCommand:(NSString*) newCommand {
    self = [super init];
    if (self) self.command = newCommand;
    return self;
}
- (id) initwithCommand:(NSString *)newCommand andData:(NSDictionary *) newData {
    self = [self initwithCommand:newCommand];
    if (self) self.data = newData;
    return self;
}
- (void) send:(SRWebSocket*) socket {
    [socket send:[self getJson]];
}
- (NSString*) getJson {
    NSMutableDictionary* json = [NSMutableDictionary dictionaryWithCapacity:2];
    [json setValue:command forKey:@"command"];
    if (self.data) [json setValue:data forKey:@"data"];
    return [json JSONRepresentation];
}
@end
