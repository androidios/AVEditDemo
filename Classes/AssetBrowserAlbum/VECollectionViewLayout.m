//
//  VECollectionViewLayout.m
//  VE
//
//  Created by XianJing on 13-6-25.
//  Copyright (c) 2013年 Sikai. All rights reserved.
//

#import "VECollectionViewLayout.h"

@implementation VECollectionViewLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *unfilteredPoses = [super layoutAttributesForElementsInRect:rect];
    id filteredPoses[unfilteredPoses.count];
    NSUInteger filteredPosesCount = 0;
    for (UICollectionViewLayoutAttributes *pose in unfilteredPoses) {
        CGRect frame = pose.frame;
        if (frame.origin.x + frame.size.width <= rect.size.width) {
            filteredPoses[filteredPosesCount++] = pose;
        }
    }
    return [NSArray arrayWithObjects:filteredPoses count:filteredPosesCount];
}

@end
