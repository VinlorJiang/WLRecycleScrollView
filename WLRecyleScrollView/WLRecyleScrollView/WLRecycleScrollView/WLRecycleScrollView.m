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
    UIPageControl *_payControl;
    UILabel *_tipLabel;
    NSTimer *_timer;
}

@end

@implementation WLRecycleScrollView

- (instancetype)initWithFrame:(CGRect)frame imageStringArray:(NSArray *)imageStringArray {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor redColor];
        _imageStringArray = [NSArray arrayWithArray:imageStringArray];
        [self createSubViews];
        [self removeTimer];
        [self addTimer];
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
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 37, self.frame.size.width, 37)];
    bgView.backgroundColor = [UIColor grayColor];
    bgView.alpha = 0.8;
    [self addSubview:bgView];
    // UIPageControl
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    CGSize size = [pageControl sizeForNumberOfPages:_imageStringArray.count];
    pageControl.bounds = CGRectMake(0, 0, size.width, size.height);
    pageControl.center = CGPointMake(bgView.frame.size.width/2, bgView.frame.size.height/2);
    pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    pageControl.numberOfPages = _imageStringArray.count;
    [bgView addSubview:pageControl];
    _payControl = pageControl;
    
    // label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(pageControl.frame) + 50, 0, 100, bgView.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor orangeColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"这是第0张图片";
    [bgView addSubview:label];
    _tipLabel = label;

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // 设置为1000倍时为了当向左滚动超出数组个数的时候就自动从0开始，不用担心会创造这么多对象消耗内存，UICollectionView会自动复用
    return _imageStringArray.count * 1000;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WLCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellID forIndexPath:indexPath];
    NSInteger index = indexPath.row % _imageStringArray.count;
    cell.imageView.image = [UIImage imageNamed:_imageStringArray[index]];
    
    return cell;
    
}
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    /** 此处注意滚动到一半的时候才让分页控制器显示下一个 */
    CGFloat offsetX = scrollView.contentOffset.x + scrollView.bounds.size.width * 0.5;
    NSUInteger index = (NSUInteger ) (offsetX / scrollView.bounds.size.width) % _imageStringArray.count;
    _payControl.currentPage = index;
    _tipLabel.text = [NSString stringWithFormat:@"这是第%lu张图片",(unsigned long)index];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    /** 开始拖拽到时候停止定时器的操作 */
    [self removeTimer];
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    /** 拖拽完成的时候 开启定时器 */
    [self addTimer];
}

- (void)addTimer {
    
    NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(timerHandler) userInfo:nil repeats:YES];
    [NSRunLoop.mainRunLoop addTimer:timer forMode:NSRunLoopCommonModes];
    _timer = timer;
}
- (void)timerHandler {
    
    CGFloat currentoffsetX = _collectionView.contentOffset.x;
    CGFloat offSetX = currentoffsetX + _collectionView.bounds.size.width;
    _tipLabel.text = [NSString stringWithFormat:@"这是第%f张图片",offSetX];
    _collectionView.contentOffset = CGPointMake(offSetX, 0);
}
- (void)removeTimer {
    [_timer invalidate];
    _timer = nil;
}

@end
