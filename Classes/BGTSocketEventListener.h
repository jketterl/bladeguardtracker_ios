//
//  BGTSocketEventListener.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 15.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int BGTSocketDisconnected = 0;
static const int BGTSocketConnected = 1;
static const int BGTSocketConnecting = 2;
static const int BGTSocketDisconnecting = 3;

@protocol BGTSocketEventListener <NSObject>
- (void) receiveUpdate: (NSDictionary*) data;
- (void) receiveStatus: (int) status;
@end
