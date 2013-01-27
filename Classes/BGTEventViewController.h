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
#import "BGTWeatherView.h"

@interface BGTEventViewController : UIViewController {
    @private BGTEvent* event;
}

@property (nonatomic) IBOutlet UILabel* nameValue;
@property (nonatomic) IBOutlet UILabel* mapNameValue;
@property (nonatomic) IBOutlet UILabel* startValue;

@property (nonatomic) IBOutlet UILabel* nameLabel;
@property (nonatomic) IBOutlet UILabel* mapNameLabel;
@property (nonatomic) IBOutlet UILabel* startLabel;
@property (nonatomic) IBOutlet UILabel* weatherLabel;

@property (nonatomic) IBOutlet UISwitch* enableSwitch;
@property (nonatomic) IBOutlet UILabel* switchLabel;

@property (nonatomic) IBOutlet BGTWeatherView* weatherView;

@property (nonatomic) IBOutlet UIButton* mapButton;

-(void) setEvent: (BGTEvent *) event;
-(IBAction) toggle:(id) sender;

@end
