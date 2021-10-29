//
//  UIImage+UIImageFilters.m
//  ImageHandler
//
//  Created by NSSimpleApps on 24.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "UIImage+UIImageFilters.h"

@implementation UIImage (UIImageFilters)

- (UIImage*)ns_rotateImageBy90Degrees {
    
    CIImage *inputCIImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *rotateCIImage = [inputCIImage imageByApplyingTransform:CGAffineTransformMakeRotation(M_PI_2)];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:rotateCIImage fromRect:rotateCIImage.extent];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return newImage;
}

- (UIImage*)ns_invertColors {
    
    CIImage *inputCIImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *outputCIImage = [CIFilter filterWithName:@"CIColorInvert" keysAndValues:kCIInputImageKey, inputCIImage, nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:outputCIImage fromRect:outputCIImage.extent];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return newImage;
}

- (UIImage*)ns_mirrorReflection {
    
    CGSize size = self.size;
    UIGraphicsBeginImageContext(size);
    
    [[UIImage imageWithCGImage:self.CGImage
                         scale:1.0
                   orientation:UIImageOrientationUpMirrored]
     drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage*)ns_monochromeTransformation {
    
    CIImage *inputCIImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *output = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:
                       kCIInputImageKey, inputCIImage,
                       @"inputIntensity", @(1.0),
                       @"inputColor", [[CIColor alloc] initWithColor:[UIColor whiteColor]], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef cgImage = [context createCGImage:output fromRect:output.extent];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    
    return newImage;
}

@end
