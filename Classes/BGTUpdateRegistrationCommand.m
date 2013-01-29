//
//  BGTUpdateRegistrationCommand.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 30.01.13.
//
//

#import "BGTUpdateRegistrationCommand.h"

@implementation BGTUpdateRegistrationCommand

- (id) initWithToken: (NSData*) token {
    NSUInteger capacity = [token length] * 2;
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:capacity];
    const unsigned char *dataBuffer = [token bytes];
    NSInteger i;
    for (i=0; i<[token length]; ++i) {
        [stringBuffer appendFormat:@"%02X", (NSUInteger)dataBuffer[i]];
    }
    
    NSDictionary* data = [NSDictionary dictionaryWithObjectsAndKeys: stringBuffer, @"regId", nil];
    self = [super initWithCommand:@"updateRegistration" andData:data];
    return self;
}

@end
