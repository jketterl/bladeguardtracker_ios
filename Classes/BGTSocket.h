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
#import "BGTApp.h"
#import <Classes/NSObject+SBJson.h>

@interface BGTSocket : NSObject <SRWebSocketDelegate> {
    @private NSMutableArray* stakes;
    @private SRWebSocket* webSocket;
    @private bool shouldBeOnline;
    @private NSTimer* reconnectTimer;
    @private NSTimer* disconnectTimer;
    @private NSMutableArray* subscriptions;
    @private NSMutableArray* backlog;
}
+ (BGTSocket *) getSharedInstance;
+ (BGTSocket *) getSharedInstanceWithStake: (id) stake;
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean;
- (BGTSocketCommand *)sendCommand:(BGTSocketCommand*) command;
- (void) addStake: (id) stake;
- (void) removeStake: (id) stake;
- (void) subscribeCategory: (NSString*) category;
- (void) subscribeCategoryArray: (NSArray *)categories;
- (void) unsubscribeCategory: (NSString*) category;
- (void) unsubscribeCategoryArray: (NSArray *)categories;
@end
