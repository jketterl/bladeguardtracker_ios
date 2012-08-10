//
//  BGTTeam.m
//  Bladeguard Tracker
//
//  Created by Jakob Ketterl on 10.08.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BGTTeam.h"

@implementation BGTTeam {
    @private int teamId;
    @private UIImage* image;
}
static NSMutableArray* teams;
static BGTTeam* anonymousTeam;

+ (BGTTeam*) teamForName: (NSString*) name {
    NSError* error;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:@"([0-9]+)" options:0 error:&error];
    NSArray* matches = [regex matchesInString:name options:0 range:NSMakeRange(0, [name length])];
    if ([matches count] > 0) {
        NSTextCheckingResult* match = [matches objectAtIndex:0];
        int teamId = [[name substringWithRange:[match range]] intValue];
        return [self teamForId:teamId];
    }
    return [self anonymousTeam];
}

+ (BGTTeam*) teamForId: (int) id {
    if (teams == NULL) teams = [NSMutableArray arrayWithCapacity:10];
    while (id > [teams count]) {
        BGTTeam* team = [[BGTTeam alloc] init];
        team->teamId = [teams count] + 1;
        [teams addObject:team];
    }
    return [teams objectAtIndex:id - 1];
}
+ (BGTTeam*) anonymousTeam {
    if (anonymousTeam == nil) {
        anonymousTeam = [[BGTTeam alloc] init];
    }
    return anonymousTeam;
}
- (UIImage*) getImage {
    if (image == nil) {
        if (teamId != 1) {
            image = [UIImage imageNamed:@"map_pin.png"];
        } else {
            // Make the input image recipe
            CIImage *inputImage = [CIImage imageWithCGImage:[UIImage imageNamed:@"map_pin.png"].CGImage];
            
            // Make the filter
            CIFilter *colorMatrixFilter = [CIFilter filterWithName:@"CIColorMatrix"];
            [colorMatrixFilter setDefaults];
            [colorMatrixFilter setValue:inputImage forKey:kCIInputImageKey];
            [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:1 Z:0 W:0] forKey:@"inputRVector"];
            [colorMatrixFilter setValue:[CIVector vectorWithX:1 Y:0 Z:0 W:0] forKey:@"inputGVector"];
            [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:1 W:0] forKey:@"inputBVector"];
            [colorMatrixFilter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:1] forKey:@"inputAVector"];
            
            // Get the output image recipe
            CIImage *outputImage = [colorMatrixFilter outputImage];
            
            // Create the context and instruct CoreImage to draw the output image recipe into a CGImage
            CIContext *context = [CIContext contextWithOptions:nil];
            CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
            
            image = [UIImage imageWithCGImage:cgimg];
        }
    }
    return image;
}

@end
