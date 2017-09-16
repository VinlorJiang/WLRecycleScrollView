//
//  WLRecycleScrollView.m
//  WLRecyleScrollView
//
//  Created by apple on 2017/9/15.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "WLRecycleScrollView.h"
#import "WLCollectionViewCell.h"

static NSString *kCollectionCellID = @"kCollectionCellID";

@interface WLRecycleScrollView ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    UICollectionView *_collectionView;
    NSArray *_imageStringArray;
}

@end

@implementation WLRecycleScrollView

- (instancetype)initWithFrame:(CGRect)frame imageStringArray:(NSArray *)imageStringArray {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        _imageStringArray = [NSArray arrayWithArray:imageStringArray];
       
        
    }
    return self;
}

- (void)createSubViews {
    
    // layout
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = self.frame.size;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    // jkl;'
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    /** 创建 collectionView 的时候就让滚蛋到100倍位置时防止一开始用户向右滚动没有数据*/
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_imageStringArray.count *100 inSection:0];
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally ];
    [collectionView registerClass:[WLCollectionViewCell class] forCellWithReuseIdentifier:kCollectionCellID];
    [self addSubview:collectionView];
    _collectionView = collectionView;
    
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _imageStringArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID forIndexPath:indexPath];
    cell.imageView.image = [UIImage imageNamed:self.imageStringArray[indexPath.row]];
//    NSLog(@"%@",cell.imageView);
//    cell.backgroundColor = indexPath.row % 2 ? [UIColor redColor] : [UIColor yellowColor];
    return cell;
    
}
#pragma mark - UICollectionViewDelegate
@end
