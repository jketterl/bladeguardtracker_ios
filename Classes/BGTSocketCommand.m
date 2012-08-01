//
//  BGTSocketCommand.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocketCommand.h"

@implementation BGTSocketCommand


- (id) init {
    self = [super init];
    if (self) {
        requestId = -1;
        callbacks = [NSMutableArray arrayWithCapacity:2];
    }
    return self;
}

- (id) initWithCommand:(NSString*) newCommand {
    self = [self init];
    if (self) command = newCommand;
    return self;
}
- (id) initWithCommand:(NSString *)newCommand andData:(NSObject *) newData {
    self = [self initWithCommand:newCommand];
    if (self) data = newData;
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
    if (res != NULL) responseData = resData;
    [self updateResultWithBool:[[resData valueForKey:@"success"] boolValue]];
}
- (void) updateResultWithBool:(BOOL)mySuccess {
    success = mySuccess;
    [self runCallbacks];
}
- (void) addCallback:(NSInvocation *)callback {
    [callbacks addObject:callback];
}
- (void) runCallbacks {
    for (NSInvocation* callback in callbacks) {
        [callback invoke];
    }
}
@end
