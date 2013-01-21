//
//  BGTEvent.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 21.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTEvent : NSObject {
    @private NSString* name;
    @private NSString* mapName;
    @private NSDate* start;
}

- (id) initWithJSON: (NSDictionary*) json;
- (NSString *) getName;
- (NSString *) getMapName;
- (NSDate *) getStart;

@end
