//
//  BGTSocketCommand.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Classes/NSObject+SBJson.h>

@interface BGTSocketCommand : NSObject {
    @private NSString* command;
    @private NSObject* data;
    @private int requestId;
    @private BOOL success;
    @private NSDictionary* responseData;
    @private NSMutableArray* callbacks;
}
- (id) initWithCommand:(NSString*) command;
- (id) initWithCommand:(NSString *)command andData:(NSObject *) data;
- (NSString *) getJson;
- (BGTSocketCommand*) setRequestId:(int) newRequestId;
- (void) updateResult:(NSDictionary*) data;
- (void) updateResultWithBool:(BOOL) success;
- (void) addCallback:(NSInvocation*) callback;
- (NSDictionary *) getResult;
- (Boolean) wasSuccessful;

- (void) setData:(NSObject*) data;
- (Boolean) isAuthCommand;
@end