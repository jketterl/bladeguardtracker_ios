//
//  BGTEvent.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 21.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "BGTEvent.h"

@implementation BGTEvent

- (id) initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        name = [json valueForKey:@"title"];
    }
    return self;
}

- (NSString *) getName {
    return name;
}

@end
