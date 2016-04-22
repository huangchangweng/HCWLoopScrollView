//
//  ViewController.m
//  Example
//
//  Created by HCW on 16/4/21.
//  Copyright © 2016年 HCW. All rights reserved.
//

#import "ViewController.h"
#import "HCWLoopScrollView/HCWLoopScrollView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet HCWLoopScrollView *sbLoopScrollView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *images = @[@"http://img.sccnn.com/bimg/311/011.jpg",
                        @"http://pic9.nipic.com/20100826/4376639_180752159879_2.jpg",
                        @"http://pic17.nipic.com/20111121/5648568_085253113104_2.jpg",
                        @"http://pic21.nipic.com/20120425/7156172_111847620387_2.jpg",
                        @"http://pic8.nipic.com/20100722/2194093_140126005826_2.jpg",
                        @"http://img3.redocn.com/20110418/20110415_9e86967f4b28360e5afbHmybhr1LpDJ5.jpg",
                        @"http://pic10.nipic.com/20101026/4690416_135348005709_2.jpg",
                        ];
    
    
    // 1.code...
    HCWLoopScrollView *loopScrollView = [HCWLoopScrollView loopScrollViewWithImageUrls:images];
    loopScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    loopScrollView.alignment = HCWPageControlAlignCenter;
    loopScrollView.timeInterval = 2;
    loopScrollView.placeholder = [UIImage imageNamed:@"you_placeholder"];
    loopScrollView.didSelectItemBlock = ^(NSInteger atIndex, UIImageView *sender) {
        
    };
    [self.view addSubview:loopScrollView];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[loopScrollView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loopScrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[loopScrollView(200)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(loopScrollView)]];
    
    // 2.storyboard
    self.sbLoopScrollView.alignment = HCWPageControlAlignLeft;
    self.sbLoopScrollView.imageUrls = images;
    self.sbLoopScrollView.timeInterval = 3;
    self.sbLoopScrollView.didSelectItemBlock = ^(NSInteger atIndex, UIImageView *sender) {
        
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
