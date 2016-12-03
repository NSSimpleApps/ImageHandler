//
//  ImageHandler.h
//  ImageHandler
//
//  Created by NSSimpleApps on 26.11.15.
//  Copyright © 2015 NSSimpleApps. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class UIImage, ImageHandler;

@protocol ImageHandlerDelegate <NSObject>

- (NSInteger)tagForInitialImageHandler:(ImageHandler *)imageHandler;

- (void)imageHandler:(ImageHandler *)imageHandler didAchieveProgress:(float)progress withTag:(NSInteger)tag;

- (void)imageHandler:(ImageHandler *)imageHandler didFinishWithImage:(UIImage *)image tag:(NSInteger)tag;

@end

typedef UIImage *_Nonnull (^HandlerBlock)(UIImage * _Nonnull);


@interface ImageHandler : NSObject

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)shared;

@property (weak, nullable) id<ImageHandlerDelegate> delegate;

- (void)syncProcessingImage:(UIImage *)image
             transformation:(HandlerBlock)handlerBlock;

- (void)asyncProcessingImage:(UIImage *)image
              transformation:(HandlerBlock)handlerBlock;

- (void)cancel;

@end

NS_ASSUME_NONNULL_END
