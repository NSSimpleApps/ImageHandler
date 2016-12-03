//
//  TableViewController.m
//  ImageHandler
//
//  Created by NSSimpleApps on 24.09.16.
//  Copyright © 2016 NSSimpleApps. All rights reserved.
//

#import "TableViewController.h"
#import "ImageCell.h"
#import "ViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) NSMutableArray<NSNumber *> *progress;

@end

@implementation TableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    ImageHandler *imageHandler = [ImageHandler shared];
    imageHandler.delegate = self;
    
    self.images = [NSMutableArray new];
    self.progress = [NSMutableArray new];
    
    NSString *reuseIdentifier = NSStringFromClass([ImageCell class]);
    
    [self.tableView registerNib:[UINib nibWithNibName:reuseIdentifier bundle:nil]
         forCellReuseIdentifier:reuseIdentifier];
}

- (ViewController *)parentController {
    
    return (ViewController *)self.parentViewController;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    [self.images removeAllObjects];
    [self.progress removeAllObjects];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageCell *cell =
    [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ImageCell class])
                                    forIndexPath:indexPath];
    
    if ([self.images[indexPath.row] isKindOfClass:[NSNull class]]) {
        
        cell.processedImageView.image = nil;
        cell.progressView.hidden = NO;
        [cell.progressView setProgress:[self.progress[indexPath.row] floatValue] animated:NO];
        
    } else {
        
        cell.progressView.hidden = YES;
        cell.processedImageView.image = self.images[indexPath.row];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 150;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return ![self.images[indexPath.row] isKindOfClass:[NSNull class]];
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewRowAction *deleteAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:@"Delete"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         
                                         [self.images removeObjectAtIndex:indexPath.row];
                                         [self.progress removeObjectAtIndex:indexPath.row];
                                         [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                     }];
    deleteAction.backgroundColor = [UIColor redColor];
    
    UITableViewRowAction *saveAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:@"Save"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         
                                         UIImage *image = self.images[indexPath.row];
                                         
                                         [self.parentController saveAssetToAlbum:image];
                                     }];
    saveAction.backgroundColor = [UIColor blueColor];
    
    UITableViewRowAction *setAsSourceAction =
    [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                       title:@"Set as source"
                                     handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
                                         
                                         [self.parentController setImageAsSource:self.images[indexPath.row]];
                                     }];
    setAsSourceAction.backgroundColor = [UIColor grayColor];
    
    return @[deleteAction, saveAction, setAsSourceAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma - mark AsyncImageHandlerDelegate

- (NSInteger)tagForInitialImageHandler:(ImageHandler *)imageHandler {
    
    [self.progress insertObject:@0 atIndex:0];
    [self.images insertObject:[NSNull null] atIndex:0];
    
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
    
    return self.images.count - 1;
}

- (void)imageHandler:(ImageHandler *)imageHandler didAchieveProgress:(float)progress withTag:(NSInteger)tag {
    
    NSInteger i = self.images.count - 1 - tag;
    
    self.progress[i] = @(progress);
    
    ImageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
    if (cell) {
        
        [cell.progressView setProgress:progress animated:NO];
    }
}

- (void)imageHandler:(ImageHandler *)imageHandler didFinishWithImage:(UIImage *)image tag:(NSInteger)tag {
    
    NSInteger i = self.images.count - 1 - tag;
    
    self.images[i] = image;
    self.progress[i] = @0;
    
    ImageCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
    
    if (cell) {
        
        cell.progressView.hidden = YES;
        cell.processedImageView.image = image;
    }
}

@end
