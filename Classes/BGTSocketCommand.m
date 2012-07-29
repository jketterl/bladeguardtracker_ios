//
//  BGTSocketCommand.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"

@implementation BGTSocketCommand

- (void) dealloc {
    [command release];
    [data release];
    if (responseData != nil) [responseData release];
    [callbacks release];
    [super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        requestId = -1;
        callbacks = [[NSMutableArray arrayWithCapacity:2] retain];
    }
    return self;
}

- (id) initwithCommand:(NSString*) newCommand {
    self = [self init];
    if (self) command = [newCommand retain];
    return self;
}
- (id) initwithCommand:(NSString *)newCommand andData:(NSObject *) newData {
    self = [self initwithCommand:newCommand];
    if (self) data = [newData retain];
    return self;
}
- (NSString*) getJson {
    NSMutableDictionary* json = [NSMutableDictionary dictionaryWithCapacity:2];
    [json setValue:command forKey:@"command"];
    if (data != nil) [json setValue:data forKey:@"data"];
    if (requestId >= 0) [json setValue:[NSNumber numberWithInt:requestId] forKey:@"requestId"];
    return [json JSONRepresentation];
}
- (BGTSocketCommand*) setRequestId:(int) newRequestId {
    requestId = newRequestId;
    return self;
}
- (void) updateResult:(NSDictionary *)resData {
    NSDictionary* res = [resData valueForKey:@"data"];
    if (res != NULL) responseData = [resData retain];
    [self updateResultWithBool:[[resData valueForKey:@"success"] boolValue]];
}
- (void) updateResultWithBool:(BOOL)mySuccess {
    success = mySuccess;
    [self runCallbacks];
}
- (void) addCallback:(NSInvocation *)callback {
    [callback retain];
    [callbacks addObject:callback];
}
- (void) runCallbacks {
    for (NSInvocation* callback in callbacks) {
        [callback invoke];
        [callback release];
    }
}
@end
