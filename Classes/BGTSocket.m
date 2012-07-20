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
        listeners = [[NSMutableArray arrayWithCapacity:10] retain];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(defaultsChanged:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void) dealloc {
    [stakes release];
    [subscriptions release];
    [listeners release];
    [super dealloc];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //NSLog(@"Received message: %@", message);
    if (![message isKindOfClass:[NSString class]]) {
        NSLog(@"binary data received");
        return;
    }
    NSDictionary* json = [message JSONValue];
    if ([[json valueForKey:@"event"] isEqual:@"update"]) {
        //NSLog(@"received update: %@", [json valueForKey:@"data"]);
        [self fireEvent:[json valueForKey:@"data"]];
    }
}
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Websocket is now open!");
    webSocket = [newWebSocket retain];
    
    [self sendHandshake];
    [self authenticate];
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
    
    [self setStatus:BGTSocketConnected];
}
- (void)authenticate {
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if (![settings boolForKey:@"anonymous"]) {
        NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:2];
        [data setValue:[settings stringForKey:@"user"] forKey:@"user"];
        [data setValue:[settings stringForKey:@"pass"] forKey:@"pass"];
        BGTSocketCommand* command = [[BGTSocketCommand alloc] initwithCommand:@"auth" andData:data];
        [webSocket send:[command getJson]];
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
    [self setStatus:BGTSocketDisconnected];
    [webSocket setDelegate:nil];
    [webSocket release];
    webSocket = nil;
    [self reConnect];
}
- (void) reConnect {
    if (!shouldBeOnline) return;
    [self close];
    //[self connect];
    if (reconnectTimer != nil) return;
    reconnectTimer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connect) userInfo:nil repeats:NO] retain];
}
- (void)defaultsChanged:(NSNotification *) notification{
    [self authenticate];
}
- (BGTSocketCommand *)sendCommand:(BGTSocketCommand*) command{
    return [self sendCommand:command doQueue:YES];
}
- (BGTSocketCommand*) sendCommand:(BGTSocketCommand*) command doQueue:(bool) queue {
    if (backlog != nil) {
        if (shouldBeOnline && queue) [backlog addObject:command];
        return command;
    }
    [webSocket send:[command getJson]];
    return command;
}
- (void) connect {
    if (webSocket) {
        if (disconnectTimer != nil) {
            [disconnectTimer invalidate];
            [disconnectTimer release];
            disconnectTimer=nil;
        }
        return;
    }
    
    [self setStatus:BGTSocketConnecting];
    
    if (reconnectTimer != nil) {
        [reconnectTimer invalidate];
        [reconnectTimer release];
        reconnectTimer = nil;
    }
    
    shouldBeOnline = YES;
    backlog = [[NSMutableArray arrayWithCapacity:10] retain];

    NSURL* url = [NSURL URLWithString:@"wss://bgt.justjakob.de/bgt/socket"];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"crt"];
    NSData *DERData = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inDERData = (__bridge CFDataRef)DERData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, inDERData);
    assert(cert != NULL);
    NSArray* certs = [NSArray arrayWithObject:(id) cert];

    [req setSR_SSLPinnedCertificates:certs];
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest:req];
    [webSocket setDelegate:self];
    [webSocket open];
}
- (void) close {
    [self setStatus:BGTSocketDisconnecting];
    shouldBeOnline = NO;
    if (backlog != nil) {
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
    disconnectTimer = [[NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(close) userInfo:nil repeats:NO] retain];
}

- (void) sendHandshake {
    NSMutableDictionary* handshake = [NSMutableDictionary dictionaryWithCapacity:3];
    [handshake setValue:@"iOS" forKey:@"platform"];
    [handshake setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [handshake setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"build"];
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

- (void) addListener: (id<BGTSocketEventListener>) listener {
    if ([listeners containsObject:listener]) return;
    [listeners addObject:listener];
}

- (void) removeListener: (id<BGTSocketEventListener>) listener {
    if (![listeners containsObject:listener]) return;    
    [listeners removeObject:listener];
}

- (void) fireEvent: (NSDictionary*) data {
    int count = [listeners count];
    for (int i = 0; i < count; i++) {
        [[listeners objectAtIndex:i] receiveUpdate:data];
    }
}

- (void) setStatus: (int) status {
    [self fireStatus:status];
}

- (void) fireStatus: (int) status {
    for (int i = 0, count = [listeners count]; i < count; i++) {
        [[listeners objectAtIndex:i] receiveStatus:status];
    }
}

@end
