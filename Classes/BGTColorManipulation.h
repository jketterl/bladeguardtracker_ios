//
//  BGTColorManipulation.h
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 12.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "math.h"

@interface BGTColorManipulation : NSObject
@property (nonatomic) float hue;
@property (nonatomic) float saturation;
@property (nonatomic) float value;

+ (BGTColorManipulation*) manipulationWithHue: (float) hue Saturation: (float) saturation Value: (float) value;

- (UIImage*) manipulateImage: (UIImage*) input;
@end
