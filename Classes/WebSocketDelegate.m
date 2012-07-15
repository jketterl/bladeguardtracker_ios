//
//  WebSocketDelegate.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebSocketDelegate.h"

@implementation WebSocketDelegate

@synthesize webSocket, shouldBeOnline, reconnectTimer, disconnectTimer, stakes;

+ (WebSocketDelegate *) getSharedInstance {
    static dispatch_once_t pred;
    static WebSocketDelegate* shared = nil;
    dispatch_once(&pred, ^{
        shared = [[WebSocketDelegate alloc] init];
    });
    return shared;
}

+ (WebSocketDelegate *) getSharedInstanceWithStake: (id) stake {
    WebSocketDelegate* socket = [WebSocketDelegate getSharedInstance];
    [socket addStake:stake];
    return socket;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //NSLog(@"Received message: %@", message);
}
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Websocket is now open!");
    webSocket = newWebSocket;
    
    [self sendHandshake];
    [self authenticate];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(defaultsChanged:)
                                                 name:NSUserDefaultsDidChangeNotification
                                               object:nil];
    
}
- (void)authenticate {
    if (!webSocket) return;
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (![settings boolForKey:@"anonymous"]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:2];
        [data setValue:[settings stringForKey:@"user"] forKey:@"user"];
        [data setValue:[settings stringForKey:@"pass"] forKey:@"pass"];
        BGTSocketCommand* command = [[BGTSocketCommand alloc] initwithCommand:@"auth" andData:data];
        [self sendCommand:command];
    }
}
- (void)webSocket:(SRWebSocket *)closingWebSocket didFailWithError:(NSError *)error {
    if (closingWebSocket != webSocket) return;
    NSLog(@"socket did close with error: %@", error);
    [self onDisconnect];
}
- (void)webSocket:(SRWebSocket *)closingWebSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if (closingWebSocket != webSocket) return;
    NSLog(@"socket did close");
    [self onDisconnect];
}
- (void) onDisconnect {
    [webSocket setDelegate:nil];
    [webSocket release];
    webSocket = nil;
    [self reConnect];
}
- (void) reConnect {
    if (!shouldBeOnline) return;
    [self close];
    //[self connect];
    reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connect) userInfo:nil repeats:NO];
}
- (void)defaultsChanged:(NSNotification *) notification{
    [self authenticate];
}
- (BGTSocketCommand *)sendCommand:(BGTSocketCommand*) command{
    if (!webSocket || webSocket.readyState != SR_OPEN) return command;
    [webSocket send:[command getJson]];
    return command;
}
- (void) connect {
    if (webSocket && disconnectTimer) {
        [disconnectTimer invalidate];
        return;
    }
    [reconnectTimer invalidate];
    shouldBeOnline = YES;
    NSURL* url = [NSURL URLWithString:@"wss://bgt.justjakob.de/bgt/socket"];
    webSocket = [[SRWebSocket alloc] initWithURL:url];
    [webSocket setDelegate:self];
    [webSocket open];
}
- (void) close {
    shouldBeOnline = NO;
    if (webSocket) [webSocket close];
}

- (NSMutableArray*) stakes {
    if (!stakes) stakes = [NSMutableArray arrayWithCapacity:10];
    return stakes;
}

- (void) addStake: (id) stake {
    [stakes addObject:stake];
    [self connect];
}

- (void) removeStake: (id) stake {
    [stakes removeObject:stake];
    if ([stakes count] >0) return;
    disconnectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(close) userInfo:nil repeats:NO];
}

- (void) sendHandshake {
    NSMutableDictionary* handshake = [NSMutableDictionary dictionaryWithCapacity:2];
    [handshake setValue:@"iOS" forKey:@"platform"];
    [handshake setValue:[BGTApp getAppVersion] forKey:@"version"];
    NSMutableDictionary* message = [NSMutableDictionary dictionaryWithCapacity:1];
    [message setValue:handshake forKey:@"handshake"];
    [webSocket send:[message JSONRepresentation]];
}

@end
