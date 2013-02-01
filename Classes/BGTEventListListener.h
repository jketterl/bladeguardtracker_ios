//
//  BGTEventListListener.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 01.02.13.
//
//

#import <Foundation/Foundation.h>

@protocol BGTEventListListener <NSObject>
- (void) onBeforeLoad;
- (void) onLoad;
@end
