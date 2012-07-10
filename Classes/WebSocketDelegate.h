//
//  WebSocketDelegate.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SocketRocket/SRWebSocket.h>
#import "BGTSocketCommand.h"

@interface WebSocketDelegate : NSObject <SRWebSocketDelegate>
@property(nonatomic,retain) SRWebSocket* webSocket;
+ (WebSocketDelegate *) getSharedInstance;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (BGTSocketCommand *)sendCommand:(BGTSocketCommand*) command;
- (void)connect;
- (void)close;
@end
