//
//  ViewController.m
//  XMProgress
//
//  Created by 忘忧 on 16/11/16.
//  Copyright © 2016年 小明. All rights reserved.
//

#import "ViewController.h"
#import "XMProgressView.h"

@interface ViewController ()<XMProgressViewDelegate, XMProgressViewDataSource>

@property(nonatomic, strong) XMProgressView *xmProgressView;
@property(nonatomic, assign) NSUInteger step;
@property(nonatomic, strong) NSArray *titles;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.xmProgressView =  [[XMProgressView alloc] init];
    [self.xmProgressView setFrame:CGRectMake(0, 100, CGRectGetMaxX(self.view.bounds), 100)];
    self.xmProgressView.backgroundColor = [UIColor redColor];
    self.xmProgressView.delegate = self;
    self.xmProgressView.dataSource = self;
    [self.view addSubview: self.xmProgressView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    btn.backgroundColor = [UIColor greenColor];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchDown];
    self.titles = @[@"等待支付",@"等待商家接单",@"等待配送",@"等待送达"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)click
{
    [self.xmProgressView setStep:self.step];
    
    if (self.step == 1) {
//        self.step = 0;
        self.titles = @[@"等待支付",@"商家已接单",@"等待配送",@"等待送达"];
//        [self.xmProgressView reload];
        [self.xmProgressView reloadWithStep:1];
    }
    self.step += 1;

}

- (NSString *)progressView:(XMProgressView *)progressView titleAtIndex:(NSUInteger)index
{
//    return [NSString stringWithFormat:@"title%lu",(unsigned long)index];
    return self.titles[index];
}

- (NSInteger)numberOfTitleData:(XMProgressView *)progressView
{
    return 4;
}

- (CGFloat)lengthOfSpaceForInterval:(XMProgressView *)progressView
{
    return 5;
}

- (CGFloat)radiusOfOuterRing:(XMProgressView *)progressView
{
    return 8;
}
- (CGFloat)radiusOfInnerRing:(XMProgressView *)progressView
{
    return 4;
}

- (CGFloat)fontForTitle:(XMProgressView *)progressView
{
    return 12;
}

- (UIColor *)colorOfStatueView:(XMProgressView *)progressView
{
    return [UIColor grayColor];
}
- (UIColor *)colorOfInterval:(XMProgressView *)progressView
{
    return [UIColor grayColor];
}

- (UIColor *)colorOfStatueViewByLight:(XMProgressView *)progressView
{
    return [UIColor blueColor];
}
- (UIColor *)colorOfIntervalBylight:(XMProgressView *)progressView
{
     return [UIColor blueColor];
}

@end
