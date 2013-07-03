//
//  VECollectionViewCell.h
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface VECollectionViewCell : UICollectionViewCell {
    UIImageView *_imageView;
}

- (void)setALAsset:(ALAsset*)asset;

@end
