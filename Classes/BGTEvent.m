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
        mapName = [json valueForKey:@"mapName"];
        
        NSDateFormatter* parser = [[NSDateFormatter alloc] init];
        // tell the parser the Z is literal (even though its actually a time zone specifier)
        [parser setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
        // and since the time zone information would be lost otherwise: fix the UTC timezone
        [parser setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        start = [parser dateFromString:[json valueForKey:@"start"]];
    }
    return self;
}

- (NSString *) getName {
    return name;
}

- (NSString *) getMapName {
    return mapName;
}

- (NSDate *) getStart {
    return start;
}

@end
