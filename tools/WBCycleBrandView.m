//
//  WBShopTableHeaderView.m
//  yeeda0925
//
//  Created by wenbin on 16/3/3.
//  Copyright © 2016年 yeeda. All rights reserved.
//

#import "WBCycleBrandView.h"
#import "UILabel+Attributed.h"
@interface WBCycleBrandView () <UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout>
{
    NSTimer *_timer;
}
@property (strong, nonatomic)UICollectionView *brandCollection;
@property (strong, nonatomic)UIPageControl *pageControl;

@end

@implementation WBCycleBrandView
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.brandCollection];
        [self addSubview:self.pageControl];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame andBrands:(NSArray *)imgArr
{
    self = [self initWithFrame:frame];
    self.brandArray = imgArr;
    return self;
}
- (UICollectionView *)brandCollection
{
    if (!_brandCollection) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize = self.frame.size;
        UICollectionView *coll = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        coll.backgroundColor = [UIColor clearColor];
        _brandCollection = coll;
        
        _brandCollection.delegate = self;
        _brandCollection.dataSource = self;
        _brandCollection.pagingEnabled = YES;
        _brandCollection.scrollsToTop = NO;
        
        _brandCollection.showsHorizontalScrollIndicator = NO;
        [_brandCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"brandCollectionCellID"];
    }
    return _brandCollection;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        UIPageControl *con = [[UIPageControl alloc]init];
        con.center = CGPointMake(kWIDTH / 2.0, self.frame.size.height - 10);
        _pageControl = con;
        
        _pageControl.numberOfPages = [self.brandArray count];
        _pageControl.currentPage = 0;
        _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.alpha = 0.8;
    }
    return _pageControl;
}
- (void)setBrandArray:(NSArray *)brandArray
{
    if (![_brandArray isEqualToArray:brandArray]) {
        [_timer invalidate];
        
        _brandArray = brandArray;
        self.pageControl.numberOfPages = brandArray.count;
        self.pageControl.currentPage = 0;
        [_brandCollection reloadData];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
        
        [_brandCollection scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2500] atScrollPosition:0 animated:NO];
    }
}
#pragma mark - 代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _brandArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 5000;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.frame.size;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"brandCollectionCellID" forIndexPath:indexPath];
    NSArray *subViews = cell.contentView.subviews;
    UIImageView *iv;
    UILabel *label;
    if (subViews.count) {
        iv = [subViews firstObject];
        label = [subViews lastObject];
    }else {
        iv = [[UIImageView alloc]initWithFrame:cell.bounds];
        iv.backgroundColor = [UIColor colorWithHexString:@"f4f5f6"];
        [cell.contentView addSubview:iv];
        
        if (self.showPlayBtn) {
            UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH - 50, self.bounds.size.height - 50, 40, 40)];
            iv.image = [UIImage imageNamed:@"showBigPlayBtn"];
            iv.center = cell.contentView.center;
            [cell.contentView addSubview:iv];
        }
        
        label = [[UILabel alloc]initWithFrame:CGRectMake(10, self.bounds.size.height - 60, kWIDTH - 20, 60)];
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        label.numberOfLines = 2;
        label.font = [toolsClass FontNameMediumWithSize:18];
        [cell.contentView addSubview:label];
    }
    if ([_brandArray.firstObject isKindOfClass:[NSString class]]) {
        NSString *urlStr = _brandArray[indexPath.row];
        [iv sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"default_16_9"]];
    }else {
        NSString *text = _brandArray[indexPath.row];
        CGFloat textH = [toolsClass calculateLableTextSize:text withFont:[toolsClass FontNameMediumWithSize:18] lineHeightFloat:25 limitSize:CGSizeMake(kWIDTH - 20, 50)].height;
        iv.image = _brandArray[indexPath.row];
        
        label.frame = CGRectMake(0, self.bounds.size.height - 10 - textH, kWIDTH - 20, textH);
    }
    if (self.titles) {
        [label attributedWithTextDefaultGrayShadow:self.titles[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(headViewClickWithIndex:)]) {
        [self.delegate headViewClickWithIndex:indexPath.row];
    }
}
- (void)nextPage
{
    NSArray *visiblesArr = self.brandCollection.indexPathsForVisibleItems;
    
    NSIndexPath *firstIndex = visiblesArr.firstObject;
    
    NSIndexPath *nextIndex = [NSIndexPath indexPathForItem:(firstIndex.row + 1)%self.brandArray.count inSection:firstIndex.section + ((firstIndex.row + 1) == self.brandArray.count ? 1 : 0)];
    
//    [UIView animateWithDuration:2 animations:^{
//        self.brandCollection.contentOffset = CGPointMake((firstIndex.row + firstIndex.section * self.brandArray.count + 1) * kWIDTH, 0);
//    }];
    [self.brandCollection scrollToItemAtIndexPath:nextIndex atScrollPosition:UICollectionViewScrollPositionNone animated:YES];

    self.pageControl.currentPage = (firstIndex.row + 1) % self.brandArray.count;
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (_brandCollection == scrollView) {
        
        self.pageControl.currentPage = (NSUInteger)((targetContentOffset->x)/(NSInteger)kWIDTH) % (self.brandArray.count);
    }
}

@end
