//
//  BGTSocketCommand.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 09.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Classes/NSObject+SBJson.h>

@interface BGTSocketCommand : NSObject
@property (nonatomic, retain) NSString* command;
@property (nonatomic, retain) NSDictionary* data;
- (id) initwithCommand:(NSString*) command;
- (id) initwithCommand:(NSString *)command andData:(NSDictionary *) data;
- (NSString *) getJson;
@end