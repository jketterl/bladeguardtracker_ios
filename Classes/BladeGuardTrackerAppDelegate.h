//
//  BladeGuardTrackerAppDelegate.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BladeGuardTrackerViewController;

@interface BladeGuardTrackerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    BladeGuardTrackerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet BladeGuardTrackerViewController *viewController;

@end

