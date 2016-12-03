//
//  ImageCell.h
//  ImageHandler
//
//  Created by NSSimpleApps on 24.09.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *processedImageView;

@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end
