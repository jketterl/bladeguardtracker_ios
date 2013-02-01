//
//  BGTFacebookLoginCommand.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import "BGTSocketCommand.h"

@interface BGTFacebookLoginCommand : BGTSocketCommand

- (id) initWithUserId:(NSString*) userId;

@end
