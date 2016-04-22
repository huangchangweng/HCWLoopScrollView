//
//  HCWLoopScrollView.h
//  Example
//
//  Created by HCW on 16/4/21.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HCWPageControlAlignment) {
    HCWPageControlAlignCenter = 1 << 1,
    HCWPageControlAlignRight  = 1 << 2,
    HCWPageControlAlignLeft  = 2 << 3,
};

@class HCWLoopScrollView;
/**
 *  回调方法，当选中item调用
 *  @param atIndex  选中的item的index
 */
typedef void (^HCWLoopScrollViewDidSelectItemBlock)(NSInteger atIndex, UIImageView *sender);
/**
 *  回调方法，当滚动item完调用
 *  @param atIndex  选中的item的index
 */
typedef void (^HCWLoopScrollViewDidScrollBlock)(NSInteger toIndex, UIImageView *sender);


@interface HCWLoopScrollView : UIView

@property (nonatomic, strong) NSArray<NSString *> *imageUrls;   ///< 图片路径数组，可以是网络图片或本地图片路径
@property (nonatomic, strong) NSArray<NSString *> *adTitles;    ///< 描述数组
@property (nonatomic, strong) UIImage *placeholder;             ///< 占位图
@property (nonatomic, assign) BOOL pageControlEnabled;          ///< 是否能点击pageControl，defult is YES
@property (nonatomic, assign) NSTimeInterval timeInterval;      ///< 自动滚动时间，defult is 5s
@property (nonatomic, assign) HCWPageControlAlignment alignment;///< 描述位置
@property (nonatomic, strong, readonly) UIPageControl *pageControl;
@property (nonatomic, copy) HCWLoopScrollViewDidScrollBlock didScrollBlock;
@property (nonatomic, copy) HCWLoopScrollViewDidSelectItemBlock didSelectItemBlock;

+ (instancetype)loopScrollViewWithImageUrls:(NSArray <NSString *> *)imageUrls;

/**
 *  Pause the timer
 */
- (void)pauseTimer;

/**
 *  Start the timer immediately
 */
- (void)startTimer;

@end
