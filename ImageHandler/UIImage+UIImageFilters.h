//
//  UIImage+UIImageFilters.h
//  ImageHandler
//
//  Created by NSSimpleApps on 24.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (UIImageFilters)

- (UIImage *)ns_rotateImageBy90Degrees;

- (UIImage *)ns_invertColors;

- (UIImage *)ns_mirrorReflection;

- (UIImage *)ns_monochromeTransformation;

@end

NS_ASSUME_NONNULL_END
