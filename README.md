# HCWLoopScrollView
无线滚动轮播控件，多用于广告等功能。
支持纯代码和storyboard方式。

![image](https://github.com/huangchangweng/HCWLoopScrollView/blob/master/HCWLoopScrollView.gif) 

### 1.代码方式

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


### 2.storyboard方式

   self.sbLoopScrollView.alignment = HCWPageControlAlignLeft;
   self.sbLoopScrollView.imageUrls = images;
   self.sbLoopScrollView.timeInterval = 3;
   self.sbLoopScrollView.didSelectItemBlock = ^(NSInteger atIndex, UIImageView *sender) {
    
   };
