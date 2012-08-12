//
//  BGTColorManipulation.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 12.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTColorManipulation.h"

@implementation BGTColorManipulation
@synthesize hue, saturation, value;

+ (BGTColorManipulation*) manipulationWithHue:(float)newHue Saturation:(float)newSaturation Value:(float)newValue {
    BGTColorManipulation* man = [[self alloc] init];
    man.hue = newHue;
    man.saturation = newSaturation;
    man.value = newValue;
    return man;
}

- (UIImage*) manipulateImage:(UIImage *)input {
    CIImage *inputImage = [CIImage imageWithCGImage:input.CGImage];
    
    float twist = fmodf(hue, 360) / 180 * M_PI;
    
    float u = cos(twist);
    float w = sin(twist);
    float v = self.value;
    float s = self.value;

    // Make the filter
    CIFilter *colorMatrixFilter = [CIFilter filterWithName:@"CIColorMatrix"];
    [colorMatrixFilter setDefaults];
    [colorMatrixFilter setValue:inputImage forKey:kCIInputImageKey];
    
    
    // for all that math see...
    // http://beesbuzz.biz/code/hsv_color_transforms.php
    [colorMatrixFilter setValue:[CIVector
                                 vectorWithX:.299 * v + .701 * v * s * u + .168 * v * s * w
                                 Y:.587 * v - .587 * v * s * u + .330 * v * s * w
                                 Z:.114 * v - .114 * v * s * u - .497 * v * s * w
                                 W:0] forKey:@"inputRVector"];
    [colorMatrixFilter setValue:[CIVector
                                 vectorWithX:.299 * v - .299 * v * s * u - .328 * v * s * w
                                 Y:.587 * v + .413 * v * s * u + .035 * v * s * w
                                 Z:.114 * v - .114 * v * s * u + .292 * v * s * w
                                 W:0] forKey:@"inputGVector"];
    [colorMatrixFilter setValue:[CIVector
                                 vectorWithX:.299 * v - .3   * v * s * u + 1.25 * v * s * w
                                 Y:.587 * v - .588 * v * s * u - 1.05 * v * s * w
                                 Z:.114 * v + .886 * v * s * u + .203 * v * s * w
                                 W:0] forKey:@"inputBVector"];
    [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
    
    // Get the output image recipe
    CIImage *outputImage = [colorMatrixFilter outputImage];
    
    // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    return [UIImage imageWithCGImage:cgimg];
}

@end
