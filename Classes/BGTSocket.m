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
        stakes = [NSMutableArray arrayWithCapacity:10];
        subscriptions = [NSMutableArray arrayWithCapacity:10];
        listeners = [NSMutableArray arrayWithCapacity:10];
        requests = [NSMutableDictionary dictionaryWithCapacity:10];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(defaultsChanged:)
                                                     name:NSUserDefaultsDidChangeNotification
                                                   object:nil];
    }
    return self;
}


- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //NSLog(@"Received message: %@", message);
    if (![message isKindOfClass:[NSString class]]) {
        NSLog(@"binary data received");
        return;
    }
    NSDictionary* json = [message JSONValue];
    if ([json valueForKey:@"requestId"] != NULL) {
        NSNumber* requestId = [json valueForKey:@"requestId"];
        BGTSocketCommand* command = [requests objectForKey:requestId];
        if (command != NULL) {
            [requests removeObjectForKey:requestId];
            [command updateResult:json];
        }
    } else if ([[json valueForKey:@"event"] isEqual:@"update"]) {
        //NSLog(@"received update: %@", [json valueForKey:@"data"]);
        [self fireEvent:[json valueForKey:@"data"]];
    }
}
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Websocket is now open!");
    webSocket = newWebSocket;
    
    [self sendHandshake];

    NSMethodSignature* sig = [self methodSignatureForSelector:@selector(onAuthentication)];
    NSInvocation* callback = [NSInvocation invocationWithMethodSignature:sig];
    [callback setTarget:self];
    [callback setSelector:@selector(onAuthentication)];
    BGTSocketCommand* command = [self authenticate];
    if (command != NULL) {
        [command addCallback:callback];
    } else {
        [callback invoke];
    }
    
    [self setStatus:BGTSocketConnected];
}
- (void) onAuthentication {
    if (backlog != nil) {
        NSArray* blCopy = backlog;
        backlog = nil;
        
        for (BGTSocketCommand* command in blCopy) {
            [self sendCommand:command];
        }
    }
    // re-subscribe to any events that have been previously subscribed, if any
    //[self subscribeCategoryArray:subscriptions];    
}
- (BGTSocketCommand*) authenticate {
    if (!shouldBeOnline) return NULL;
    NSUserDefaults* settings = [NSUserDefaults standardUserDefaults];
    if ([settings boolForKey:@"anonymous"]) return NULL;
    
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithCapacity:2];
    [data setValue:[settings stringForKey:@"user"] forKey:@"user"];
    [data setValue:[settings stringForKey:@"pass"] forKey:@"pass"];
    BGTSocketCommand* command = [[BGTSocketCommand alloc] initWithCommand:@"auth" andData:data];
    [self sendCommand:command doQueue:NO bypass:YES];
    return command;
}
- (void)webSocket:(SRWebSocket *)closingWebSocket didFailWithError:(NSError *)error {
    if (closingWebSocket != webSocket) return;
    NSLog(@"socket did close with error: %@", error);
    [self onDisconnect];
}
- (void)webSocket:(SRWebSocket *)closingWebSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    if (closingWebSocket != webSocket) return;
    NSLog(@"socket did close with code %i (reason: %@)", code, reason);
    [self onDisconnect];
}
- (void) onDisconnect {
    [self setStatus:BGTSocketDisconnected];
    [webSocket setDelegate:nil];
    webSocket = nil;
    [self reConnect];
}
- (void) reConnect {
    if (!shouldBeOnline) return;
    [self close];
    //[self connect];
    if (reconnectTimer != nil) return;
    reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(connect) userInfo:nil repeats:NO];
}
- (void)defaultsChanged:(NSNotification *) notification{
    [self authenticate];
}
- (BGTSocketCommand *)sendCommand:(BGTSocketCommand*) command{
    return [self sendCommand:command doQueue:YES];
}
- (BGTSocketCommand*) sendCommand:(BGTSocketCommand*) command doQueue:(bool) queue {
    return [self sendCommand:command doQueue:queue bypass:NO];
}
- (BGTSocketCommand*) sendCommand:(BGTSocketCommand*) command doQueue:(bool) queue bypass:(bool) bypass {
    if (backlog != nil && !bypass) {
        if (shouldBeOnline && queue) [backlog addObject:command];
        return command;
    }
    [requests setObject:command forKey:[NSNumber numberWithInt:requestCount]];
    [command setRequestId:requestCount++];
    [webSocket send:[command getJson]];
    return command;
}
- (void) connect {
    if (webSocket) {
        if (disconnectTimer != nil) {
            [disconnectTimer invalidate];
            disconnectTimer=nil;
        }
        return;
    }
    
    [self setStatus:BGTSocketConnecting];
    
    if (reconnectTimer != nil) {
        [reconnectTimer invalidate];
        reconnectTimer = nil;
    }
    
    shouldBeOnline = YES;
    backlog = [NSMutableArray arrayWithCapacity:10];

    NSURL* url = [NSURL URLWithString:@"wss://bgt.justjakob.de/bgt/socket"];
    NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *thePath = [[NSBundle mainBundle] pathForResource:@"server" ofType:@"crt"];
    NSData *DERData = [[NSData alloc] initWithContentsOfFile:thePath];
    CFDataRef inDERData = (__bridge CFDataRef)DERData;
    SecCertificateRef cert = SecCertificateCreateWithData(NULL, inDERData);
    assert(cert != NULL);
    NSArray* certs = [NSArray arrayWithObject:(id) (__bridge id) cert];

    [req setSR_SSLPinnedCertificates:certs];
    
    webSocket = [[SRWebSocket alloc] initWithURLRequest:req];
    [webSocket setDelegate:self];
    [webSocket open];
}
- (void) close {
    [self setStatus:BGTSocketDisconnecting];
    shouldBeOnline = NO;
    if (backlog != nil) {
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
    NSMutableDictionary* handshake = [NSMutableDictionary dictionaryWithCapacity:3];
    [handshake setValue:@"iOS" forKey:@"platform"];
    [handshake setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] forKey:@"version"];
    [handshake setValue:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"] forKey:@"build"];
    NSMutableDictionary* message = [NSMutableDictionary dictionaryWithCapacity:1];
    [message setValue:handshake forKey:@"handshake"];
    [webSocket send:[message JSONRepresentation]];
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
