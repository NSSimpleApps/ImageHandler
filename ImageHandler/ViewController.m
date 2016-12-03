//
//  ViewController.m
//  ImageHandler
//
//  Created by NSSimpleApps on 24.05.15.
//  Copyright (c) 2015 NSSimpleApps. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+UIImageFilters.h"
#import "ImageHandler.h"
#import "TableViewController.h"

@import Photos;

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (copy, nonatomic) NSString* existingAlbumIdentifier;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

- (IBAction)rotateImageAction {
    
    UIImage *image = self.imageView.image;
    
    if (image) {
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            [[ImageHandler shared] asyncProcessingImage:image
                                         transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                             
                                             return [image ns_rotateImageBy90Degrees];
                                         }];
            
        } else if (self.segmentedControl.selectedSegmentIndex == 1) {
            
            [[ImageHandler shared] syncProcessingImage:image
                                        transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                            
                                            return [image ns_rotateImageBy90Degrees];
                                        }];
        }
    }
}

- (IBAction)invertColorsAction {
    
    UIImage *image = self.imageView.image;
    
    if (image) {
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            [[ImageHandler shared] asyncProcessingImage:image
                                         transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                             
                                             return [image ns_invertColors];
                                         }];
            
        } else if (self.segmentedControl.selectedSegmentIndex == 1) {
            
            [[ImageHandler shared] syncProcessingImage:image
                                        transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                            
                                            return [image ns_invertColors];
                                        }];
        }
    }
}

- (IBAction)mirrorReflectionAction {
    
    UIImage *image = self.imageView.image;
    
    if (image) {
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            [[ImageHandler shared] asyncProcessingImage:image
                                         transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                             
                                             return [image ns_mirrorReflection];
                                         }];
            
        } else if (self.segmentedControl.selectedSegmentIndex == 1) {
            
            [[ImageHandler shared] syncProcessingImage:image
                                        transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                            
                                            return [image ns_mirrorReflection];
                                        }];
        }
    }
}

- (IBAction)monochromeTransformationAction {
    
    UIImage *image = self.imageView.image;
    
    if (image) {
        
        if (self.segmentedControl.selectedSegmentIndex == 0) {
            
            [[ImageHandler shared] asyncProcessingImage:image
                                         transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                             
                                             return [image ns_monochromeTransformation];
                                         }];
            
        } else if (self.segmentedControl.selectedSegmentIndex == 1) {
            
            [[ImageHandler shared] syncProcessingImage:image
                                        transformation:^UIImage * _Nonnull(UIImage * _Nonnull image) {
                                            
                                            return [image ns_monochromeTransformation];
                                        }];
        }
    }
}

#pragma - mark Pick up image

- (IBAction)pickUpAnImageAction:(UIButton *)sender {
    
    [sender removeFromSuperview];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureOnImageView)];
    
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    [self handleTapGestureOnImageView];
}

- (void)handleTapGestureOnImageView {
    
    UIImagePickerController* imagePicker = [UIImagePickerController new];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma - mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
        self.imageView.image = info[UIImagePickerControllerOriginalImage];
    }];
}

#pragma - mark image handling

- (void)setImageAsSource:(UIImage *)image {
    
    self.imageView.image = image;
}

- (void)saveAssetToAlbum:(UIImage *)image {
    
    __block NSString* albumIdentifier = self.existingAlbumIdentifier;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        
        PHFetchResult* fetchCollectionResult;
        
        if (albumIdentifier) {
            
            fetchCollectionResult = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[albumIdentifier] options:nil];
        }
        
        PHAssetCollectionChangeRequest *collectionRequest = nil;
        
        if (!fetchCollectionResult || [fetchCollectionResult count] ==0) {
            
            collectionRequest = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:@"ImageHandler"];
            albumIdentifier = collectionRequest.placeholderForCreatedAssetCollection.localIdentifier;
            
        } else {
            
            PHAssetCollection* exisitingCollection = fetchCollectionResult.firstObject;
            collectionRequest = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:exisitingCollection];
        }
        
        PHAssetChangeRequest* createAssetRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        
        [collectionRequest addAssets:@[createAssetRequest.placeholderForCreatedAsset]];
        
    } completionHandler:^(BOOL success, NSError *error) {
        
        if (success) {
            
            self.existingAlbumIdentifier = albumIdentifier;
            
        } else {
            
            NSLog(@"%@", error);
        }
    }];
}

@end
