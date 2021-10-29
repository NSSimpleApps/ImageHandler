//
//  ViewController.h
//  ImageHandler
//
//  Created by NSSimpleApps on 24.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewController : UIViewController

- (void)setImageAsSource:(UIImage *)image;

- (void)saveAssetToAlbum:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
