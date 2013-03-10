//
//  BGTUserMarker.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "BGTUser.h"

@interface BGTUserMarker : MKPointAnnotation
- (id) initWithUser: (BGTUser*) user;
- (BGTUser*) getUser;
@end
