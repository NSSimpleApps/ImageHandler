//
//  AsyncImageHandler.m
//  AsyncImageHandler
//
//  Created by NSSimpleApps on 26.11.15.
//  Copyright © 2015 NSSimpleApps. All rights reserved.
//

#import "ImageHandler.h"

@interface ImageHandler ()

@property (strong, nonatomic) NSOperationQueue *operationQueue;

@end

@implementation ImageHandler

+ (instancetype)shared {
    
    static ImageHandler *imageHandler = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        imageHandler = [[self alloc] init];
    });
    
    return imageHandler;
}

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.operationQueue = [NSOperationQueue new];
    }
    return self;
}

- (void)cancel {
    
    [self.operationQueue cancelAllOperations];
}

- (void)syncProcessingImage:(UIImage *)image
             transformation:(HandlerBlock)handlerBlock {
    
    id<ImageHandlerDelegate> delegate = self.delegate;
    
    if (delegate) {
        
        NSInteger tag = [delegate tagForInitialImageHandler:self];
        
        
        [delegate imageHandler:self didAchieveProgress:1 withTag:tag];
        
        UIImage *result = handlerBlock(image);
        
        [delegate imageHandler:self didFinishWithImage:result tag:tag];
    }
}

- (void)asyncProcessingImage:(UIImage *)image
              transformation:(HandlerBlock)handlerBlock {
    
    id<ImageHandlerDelegate> delegate = self.delegate;
    
    if (delegate) {
        
        NSInteger tag = [delegate tagForInitialImageHandler:self];
        
        NSBlockOperation *blockOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSInteger duration = arc4random_uniform(4) + 1;
            
            for (NSInteger index = 1; index <= duration; index++) {
                
                sleep(1);
                
                float progress = (float)index/duration;
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [delegate imageHandler:self didAchieveProgress:progress withTag:tag];
                });
            }
        }];
        
        blockOperation.completionBlock = ^{
            
            UIImage *result = handlerBlock(image);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [delegate imageHandler:self didFinishWithImage:result tag:tag];
            });
        };
        
        [self.operationQueue addOperation:blockOperation];
    }
}

@end
