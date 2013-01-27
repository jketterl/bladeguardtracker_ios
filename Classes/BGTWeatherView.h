//
//  weatherView.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 27.01.13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BGTWeatherView : UIView {
    NSNumber* value;
  @private
    UILabel* label;
    UIImageView* image;
}

@property (nonatomic) NSNumber* value;

@end
