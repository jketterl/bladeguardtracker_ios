//
//  WebSocketDelegate.m
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 08.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WebSocketDelegate.h"

@implementation WebSocketDelegate

@synthesize webSocket;

+ (WebSocketDelegate *) getSharedInstance {
    static dispatch_once_t pred;
    static WebSocketDelegate* shared = nil;
    dispatch_once(&pred, ^{
        shared = [[WebSocketDelegate alloc] init];
    });
    return shared;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    //NSLog(@"Received message: %@", message);
}
- (void)webSocketDidOpen:(SRWebSocket *)newWebSocket {
    NSLog(@"Websocket is now open!");
    webSocket = newWebSocket;
    
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
- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
}
- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    
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
    //if (!webSocket) {
        NSURL* url = [NSURL URLWithString:@"wss://bgt.justjakob.de/bgt/socket"];
        webSocket = [[SRWebSocket alloc] initWithURL:url];
        [webSocket setDelegate:self];
    //}
    [webSocket open];
}
- (void) close {
    [webSocket close];
    [webSocket release];
}
@end
