//
//  VEImagePickerViewController.h
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AssetBrowserController.h"

@interface VEMediaPickerViewController : UICollectionViewController
{
    id <AssetBrowserControllerDelegate> _delegate;
}

@property(nonatomic, strong) NSMutableArray *usingAssetArray;
@property(nonatomic, strong) NSMutableArray *photoAssetList;
@property(nonatomic, strong) NSMutableArray *videoAssetList;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, assign) id<AssetBrowserControllerDelegate> delegate;

@end


