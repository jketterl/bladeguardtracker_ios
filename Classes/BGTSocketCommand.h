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
}
- (id) initwithCommand:(NSString*) command;
- (id) initwithCommand:(NSString *)command andData:(NSObject *) data;
- (NSString *) getJson;
@end