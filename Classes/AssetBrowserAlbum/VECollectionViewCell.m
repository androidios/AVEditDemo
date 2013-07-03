//
//  VECollectionViewCell.m
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import "VECollectionViewCell.h"

@implementation VECollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setALAsset:(ALAsset *)asset {
    NSArray *subViews = [self.contentView subviews];
    for (int i = 0; i < [subViews count]; ++i) {
        UIView *view = [subViews objectAtIndex:i];
        [view removeFromSuperview];
    }
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 75)];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_imageView];
    [_imageView setImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    
    NSString *type = [asset valueForProperty:ALAssetPropertyType];
    
    if ([type compare:ALAssetTypeVideo] == NSOrderedSame) {
        UIImageView *videoDurationImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"video_duration_bg.png"]];
        videoDurationImageView.frame = CGRectMake(0, self.frame.size.height - videoDurationImageView.frame.size.height, videoDurationImageView.frame.size.width, videoDurationImageView.frame.size.height);
        
        UILabel *videoDuration = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, videoDurationImageView.frame.size.width - 3, videoDurationImageView.frame.size.height)];
        videoDuration.backgroundColor = [UIColor clearColor];
        double seconds = [[asset valueForProperty:@"ALAssetPropertyDuration"] doubleValue] + 0.5;
        videoDuration.font = [UIFont boldSystemFontOfSize:10];
        videoDuration.textColor = [UIColor whiteColor];
        videoDuration.textAlignment = NSTextAlignmentRight;
        
        [videoDurationImageView addSubview:videoDuration];
        [self.contentView addSubview:videoDurationImageView];
    }
}

@end
