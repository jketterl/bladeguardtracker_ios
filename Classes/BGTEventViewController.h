//
//  BGTEventViewController.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 22.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGTEvent.h"
#import "BGTMapViewController.h"
#import "GPSDelegate.h"

@interface BGTEventViewController : UIViewController {
    @private BGTEvent* event;
}

@property (nonatomic) IBOutlet UILabel* nameLabel;
@property (nonatomic) IBOutlet UILabel* mapNameLabel;
@property (nonatomic) IBOutlet UILabel* startLabel;
@property (nonatomic) IBOutlet UILabel* weatherLabel;

@property (nonatomic) IBOutlet UISwitch* enableSwitch;

-(void) setEvent: (BGTEvent *) event;
-(IBAction) toggle:(id) sender;

@end
