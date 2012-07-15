//
//  BladeGuardTrackerAppDelegate.h
//  BladeGuardTracker
//
//  Created by Jakob Ketterl on 04.07.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BladeGuardTrackerViewController;

@interface BladeGuardTrackerAppDelegate : UIResponder <UIApplicationDelegate> {
    UIWindow *window;
    BladeGuardTrackerViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
//@property (nonatomic, retain) IBOutlet BladeGuardTrackerViewController *viewController;

@end

