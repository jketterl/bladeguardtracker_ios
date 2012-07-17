//
//  BGTSocketEventListener.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BGTSocketEventListener <NSObject>
- (void) receiveUpdate: (NSDictionary*) data;
@end