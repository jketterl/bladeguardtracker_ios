//
//  WebSocketDelegate.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTSocket.h"

@implementation BGTSocket

+ (BGTSocket *) getSharedInstance {
    static dispatch_once_t pred;
    static BGTSocket* shared = nil;
    dispatch_once(&pred, ^{
        shared = [[BGTSocket alloc] init];
    });
    return shared;
}

+ (BGTSocket *) getSharedInstanceWithStake: (id) stake {
    BGTSocket* socket = [BGTSocket getSharedInstance];
    [socket addStake:stake];
    return socket;
}

- (id) init {
    self = [super init];
    if (self) {
        stakes = [[NSMutableArray arrayWithCapacity:10] retain];
        subscriptions = [[NSMutableArray arrayWithCapacity:10] retain];
    }
    return self;
}

- (void) dealloc {
    [stakes release];
    [subscriptions release];
    [super dealloc];
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
    
    // re-subscribe to any events that have been previously subscribed, if any
    [self subscribeCategoryArray:subscriptions];
    
    if (backlog != nil) {
        int count = [backlog count];
        for (int i = 0; i < count; i++) {
            [self sendCommand:[backlog objectAtIndex:i]];
        }
        [backlog release];
        backlog = nil;
    }
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
    return [self sendCommand:command doQueue:YES];
}
- (BGTSocketCommand*) sendCommand:(BGTSocketCommand*) command doQueue:(bool) queue {
    if (!webSocket || webSocket.readyState != SR_OPEN) {
        if (shouldBeOnline && queue) [backlog addObject:command];
        return command;
    }
    [webSocket send:[command getJson]];
    return command;
}
- (void) connect {
    if (webSocket) {
        if (disconnectTimer) [disconnectTimer invalidate];
        return;
    }
    [reconnectTimer invalidate];
    shouldBeOnline = YES;
    backlog = [[NSMutableArray arrayWithCapacity:10] retain];
    NSURL* url = [NSURL URLWithString:@"wss://bgt.justjakob.de/bgt/socket"];
    webSocket = [[SRWebSocket alloc] initWithURL:url];
    [webSocket setDelegate:self];
    [webSocket open];
}
- (void) close {
    shouldBeOnline = NO;
    if (backlog) {
        [backlog release];
        backlog = nil;
    }
    if (webSocket) [webSocket close];
}

- (void) addStake: (id) stake {
    if ([stakes containsObject:stake]) return;
    [stakes addObject:stake];
    [self connect];
    //NSLog(@"# of stakes is now: %i", [stakes count]);
}

- (void) removeStake: (id) stake {
    if (![stakes containsObject:stake]) return;
    [stakes removeObject:stake];
    //NSLog(@"# of stakes is now: %i", [stakes count]);
    if ([stakes count] > 0) return;
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

- (void) subscribeCategory: (NSString*) category {
    NSArray* categories = [NSArray arrayWithObjects:category, nil];
    [self subscribeCategoryArray:categories];
}

- (void) subscribeCategoryArray: (NSArray*) categories {
    NSDictionary* data = [NSDictionary dictionaryWithObject:categories forKey:@"category"];
    BGTSocketCommand* command = [[BGTSocketCommand alloc] initwithCommand:@"subscribeUpdates" andData:data];
    [self sendCommand:command doQueue:NO];
    [subscriptions addObjectsFromArray:categories];
}

- (void) unsubscribeCategory: (NSString*) category {
    NSArray* categories = [NSArray arrayWithObjects:category, nil];
    [self unsubscribeCategoryArray:categories];
}

- (void) unsubscribeCategoryArray: (NSArray *) categories {
    NSDictionary* data = [NSDictionary dictionaryWithObject:categories forKey:@"category"];
    BGTSocketCommand* command = [[BGTSocketCommand alloc] initwithCommand:@"unSubscribeUpdates" andData:data];
    [self sendCommand:command doQueue:NO];
    [subscriptions removeObjectsInArray:categories];
}

@end
