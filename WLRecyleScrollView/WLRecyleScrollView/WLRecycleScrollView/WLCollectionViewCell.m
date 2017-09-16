//
//  WLCollectionViewCell.m
//  WLRecyleScrollView
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WLCollectionViewCell.h"

@implementation WLCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    
//    self.imageView = [[UIImageView alloc] initWithFrame:self.frame];
//    [self addSubview:self.imageView];
//}


@end
