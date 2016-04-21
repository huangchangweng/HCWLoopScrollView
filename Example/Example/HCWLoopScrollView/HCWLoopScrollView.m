//
//  HCWLoopScrollView.m
//  Example
//
//  Created by HCW on 16/4/21.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import "HCWLoopScrollView.h"
#import "UIImageView+WebCache.h"

NSString * const kCellIdentifier = @"ReuseCellIdentifier";

/**
 *  CollectionView for ad.
 */
@interface HCWCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView   *imageView;
@property (nonatomic, strong) UILabel       *titleLabel;

@end

@implementation HCWCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        // imageView
        self.imageView = [[UIImageView alloc] init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.imageView];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_imageView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_imageView)]];
        
        
        // titleLabel
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        self.titleLabel.hidden = YES;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.titleLabel];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_titleLabel]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_titleLabel(30)]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_titleLabel)]];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.hidden = self.titleLabel.text.length > 0 ? NO : YES;
}

@end

@interface HCWLoopScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, assign) NSInteger previousPageIndex;
@end

@implementation HCWLoopScrollView

- (void)pauseTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)startTimer {
    if (self.timer) {
        [self.timer setFireDate:[NSDate distantPast]];
    }
}

+ (instancetype)loopScrollViewWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls {
    HCWLoopScrollView *loopView = [[HCWLoopScrollView alloc] initWithFrame:frame];
    loopView.imageUrls = imageUrls;
    
    return loopView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.timeInterval = 5.0;
        self.alignment = HCWPageControlAlignCenter;
        [self configCollectionView];
    }
    return self;
}

- (void)configCollectionView {
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout .minimumLineSpacing = 0;
    self.layout .scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                             collectionViewLayout:self.layout];
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    [self.collectionView  registerClass:[HCWCollectionCell class]
             forCellWithReuseIdentifier:kCellIdentifier];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self addSubview:self.collectionView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_collectionView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_collectionView)]];
}

- (void)configTimer {
    [_timer invalidate];
    _timer = nil;
    
    if (self.imageUrls.count <= 1) {
        return;
    }
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                              target:self
                                            selector:@selector(autoScroll)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/*
- (void)setPageControlEnabled:(BOOL)pageControlEnabled {
    if (_pageControlEnabled != pageControlEnabled) {
        _pageControlEnabled = pageControlEnabled;
        
        if (_pageControlEnabled) {
            __weak typeof(self) weakSelf = self;
            self.pageControl.valueChangedBlock = ^(NSInteger clickedAtIndex) {
                NSInteger curIndex = (weakSelf.collectionView.contentOffset.x
                                      + weakSelf.layout.itemSize.width * 0.5) / weakSelf.layout.itemSize.width;
                NSInteger toIndex = curIndex + (clickedAtIndex > weakSelf.previousPageIndex ? clickedAtIndex : -clickedAtIndex);
                [weakSelf.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:toIndex inSection:0]
                                                atScrollPosition:UICollectionViewScrollPositionNone
                                                        animated:YES];
                
            };
        } else {
            self.pageControl.valueChangedBlock = nil;
        }
    }
}
 */

- (void)configPageControl {
    if (self.pageControl == nil) {
        _pageControl = [[UIPageControl alloc] init];
        self.pageControl.translatesAutoresizingMaskIntoConstraints = NO;
        self.pageControl.hidesForSinglePage = YES;
        [self addSubview:self.pageControl];
        self.pageControlEnabled = YES;
        
        CGSize size = [self.pageControl sizeForNumberOfPages:self.imageUrls.count];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_pageControl(height)]-5-|"
                                                                     options:0
                                                                     metrics:@{@"height": @(size.height)}
                                                                       views:NSDictionaryOfVariableBindings(_pageControl)]];
        NSString *vfl_H = @"[_pageControl(width)]";
        
        if (self.alignment == HCWPageControlAlignCenter) {
            vfl_H = @"[_pageControl(width)]";
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self.pageControl
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0]];
        } else if (self.alignment == HCWPageControlAlignRight) {
            vfl_H = @"|-10-[_pageControl(width)]";
        } else if (self.alignment == HCWPageControlAlignRight) {
            vfl_H = @"[_pageControl(width)]-10-|";
        }
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl_H
                                                                     options:0
                                                                     metrics:@{@"width": @(size.width)}
                                                                       views:NSDictionaryOfVariableBindings(_pageControl)]];
    }
    
    [self bringSubviewToFront:self.pageControl];
    self.pageControl.numberOfPages = self.imageUrls.count;
    
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval {
    _timeInterval = timeInterval;
    
    [self configTimer];
}

- (void)autoScroll {
    NSInteger curIndex = (self.collectionView.contentOffset.x + self.bounds.size.width * 0.5) / self.bounds.size.width;
    NSInteger toIndex = curIndex + 1;
    
    NSIndexPath *indexPath = nil;
    if (toIndex == self.totalPageCount) {
        toIndex = self.totalPageCount * 0.5;
        
        // scroll to the middle without animation, and scroll to middle with animation, so that it scrolls
        // more smoothly.
        indexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    } else {
        indexPath = [NSIndexPath indexPathForItem:toIndex inSection:0];
    }
    
    [self.collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:YES];
}

- (void)setImageUrls:(NSArray *)imageUrls {
    if (_imageUrls != imageUrls) {
        _imageUrls = imageUrls;
        
        if (imageUrls.count > 1) {
            self.totalPageCount = imageUrls.count * 50;
            [self configTimer];
            [self configPageControl];
            self.collectionView.scrollEnabled = YES;
        } else {
            // If there is only one page, stop the timer and make scroll enabled to be NO.
            [_timer invalidate];
            _timer = nil;
            self.totalPageCount = 1;
            [self configPageControl];
            self.collectionView.scrollEnabled = NO;
        }
        [self.collectionView reloadData];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.layout.itemSize = self.bounds.size;
    if (self.collectionView.contentOffset.x == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.totalPageCount * 0.5
                                                     inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath
                                    atScrollPosition:UICollectionViewScrollPositionNone
                                            animated:NO];
    }
    
    [self configPageControl];
}

- (void)setAlignment:(HCWPageControlAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        
        [self configPageControl];
        [self.collectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.totalPageCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HCWCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier
                                                                        forIndexPath:indexPath];
    
    NSInteger itemIndex = indexPath.item % self.imageUrls.count;
    if (itemIndex < self.imageUrls.count) {
        NSString *urlString = self.imageUrls[itemIndex];
        if ([urlString isKindOfClass:[UIImage class]]) {
            cell.imageView.image = (UIImage *)urlString;
        } else if ([urlString hasPrefix:@"http://"]
                   || [urlString hasPrefix:@"https://"]
                   || [urlString containsString:@"/"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:self.placeholder];
        } else {
            cell.imageView.image = [UIImage imageNamed:urlString];
        }
    }
    
    if (self.alignment == HCWPageControlAlignRight && itemIndex < self.adTitles.count) {
        cell.titleLabel.text = [NSString stringWithFormat:@"   %@", self.adTitles[itemIndex]];
    }
    if (self.alignment == HCWPageControlAlignLeft && itemIndex < self.adTitles.count) {
        cell.titleLabel.text = [NSString stringWithFormat:@"%@   ", self.adTitles[itemIndex]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didSelectItemBlock) {
        HCWCollectionCell *cell = (HCWCollectionCell *)[self collectionView:collectionView cellForItemAtIndexPath:indexPath];
        self.didSelectItemBlock(indexPath.item % self.imageUrls.count, cell.imageView);
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int itemIndex = (scrollView.contentOffset.x + self.collectionView.bounds.size.width * 0.5) / self.collectionView.bounds.size.width;
    itemIndex = itemIndex % self.imageUrls.count;
    _pageControl.currentPage = itemIndex;
    
    // record
    self.previousPageIndex = itemIndex;
    
    CGFloat x = scrollView.contentOffset.x - self.collectionView.bounds.size.width;
    NSUInteger index = fabs(x) / self.collectionView.bounds.size.width;
    CGFloat fIndex = fabs(x) / self.collectionView.bounds.size.width;
    
    if (self.didScrollBlock && fabs(fIndex - (CGFloat)index) <= 0.00001) {
        HCWCollectionCell *cell = (HCWCollectionCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        self.didScrollBlock(itemIndex, cell.imageView);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_timer invalidate];
    _timer = nil;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self configTimer];
}

@end
