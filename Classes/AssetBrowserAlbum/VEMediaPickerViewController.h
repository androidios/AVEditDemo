//
//  VEImagePickerViewController.h
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@protocol AssetBrowserAlbumControllerDelegate;

@interface VEMediaPickerViewController : UICollectionViewController
{
    id <AssetBrowserAlbumControllerDelegate> _delegate;
}

@property(nonatomic, strong) NSMutableArray *usingAssetArray;
@property(nonatomic, strong) NSMutableArray *photoAssetList;
@property(nonatomic, strong) NSMutableArray *videoAssetList;

@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (nonatomic, assign) id<AssetBrowserAlbumControllerDelegate> delegate;

@end


@protocol AssetBrowserAlbumControllerDelegate <NSObject>
@optional

// It is the delegate's responsibility to dismiss the modal view controller on the parent view controller.
- (void)assetBrowserAlbum:(ALAsset *)asset;
- (void)assetBrowserAlbumDidCancel;

@end


