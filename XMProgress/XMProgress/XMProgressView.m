//
//  XMProgressView.m
//  XMProgress
//
//  Created by 忘忧 on 16/11/16.
//  Copyright © 2016年 小明. All rights reserved.
//

#import "XMProgressView.h"

static NSUInteger defaultNumberOfStatueView = 4;

@interface XMProgressView()

@property(nonatomic, assign) BOOL isFirstLoad;
@property(nonatomic, assign) NSUInteger numberOfStatueView;
@property(nonatomic, assign) NSUInteger step;
@property(nonatomic, assign) CGFloat radiusOfOuterRing;
@property(nonatomic, assign) CGFloat radiusOfInnerRing;
@property(nonatomic, assign) CGFloat lengthOfSpaceForInterval;
@property(nonatomic, assign) CGFloat fontForTitle;
@property(nonatomic, strong) UIColor *colorOfStatueView;
@property(nonatomic, strong) UIColor *colorOfStatueViewLight;
@property(nonatomic, strong) UIColor *colorOfInterval;
@property(nonatomic, strong) UIColor *colorOfIntervalLight;
@property(nonatomic, strong) NSMutableArray *arrayOfStatueView;
@property(nonatomic, strong) NSMutableArray *arrayOfStatueTitleLabel;
@property(nonatomic, strong) NSMutableArray *arrayOfStatueIntervalView;

@end

@implementation XMProgressView


- (id)init
{
    self = [super init];
    if (self) {
        self.isFirstLoad = YES;
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateProperty];
    
    if (self.isFirstLoad) {
        [self initStatueViews];
        [self initStatueTitleLables];
        [self initStatueIntervalView];
        self.isFirstLoad = NO;
    }
    
    for (id object in self.subviews) {
        [object removeFromSuperview];
    }
    
    CGFloat widthOfInterval = (CGRectGetWidth(self.bounds) - self.numberOfStatueView * self.radiusOfOuterRing) / self.numberOfStatueView;
    
    for (NSUInteger i = 0; i < self.numberOfStatueView; i++) {
        UIView *view;
        if (i < self.arrayOfStatueView.count) {
            view = self.arrayOfStatueView[i];
        } else {
            view = [self creatStatueView];
            [self.arrayOfStatueView addObject:view];
        }
        
        [view setFrame:CGRectMake(widthOfInterval / 2 + i * (widthOfInterval + self.radiusOfOuterRing), CGRectGetMidY(self.bounds) - self.radiusOfOuterRing / 2, self.radiusOfOuterRing, self.radiusOfOuterRing)];
        [self addSubview:view];
        
        
        UILabel *label;
        if (i < self.arrayOfStatueTitleLabel.count) {
            label = self.arrayOfStatueTitleLabel[i];
        } else {
            label = [self creatStatueTitleLabel];
            [self.arrayOfStatueTitleLabel addObject:label];
        }
        label.font = [UIFont systemFontOfSize:self.fontForTitle];
        NSString *string;
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(progressView:titleAtIndex:)]){
            string = [self.dataSource progressView:self titleAtIndex:i];
        }
        if (!string) {
            string = @"";
        }
        label.text = string;
        [label setFrame:CGRectMake(i * (widthOfInterval + self.radiusOfOuterRing), CGRectGetMinY(view.frame) - 25, widthOfInterval + self.radiusOfOuterRing, 20)];
        [self addSubview:label];

        if (i != self.numberOfStatueView -1) {
            UIView *intervalView;
            if (i < self.arrayOfStatueIntervalView.count) {
                intervalView = self.arrayOfStatueIntervalView[i];
            } else {
                intervalView = [UIView new];
                [self.arrayOfStatueIntervalView addObject:intervalView];
            }
            intervalView.backgroundColor = self.colorOfInterval;
            [intervalView setFrame:CGRectMake(CGRectGetMaxX(view.frame) + self.lengthOfSpaceForInterval, CGRectGetMidY(view.frame) - self.radiusOfOuterRing / 8, widthOfInterval - self.lengthOfSpaceForInterval * 2, self.radiusOfOuterRing / 4)];
            [self addSubview:intervalView];
        }
    }
    [self updateByStep];
}

#pragma mark Public Methods

- (void)reload
{
    _step = 0;
    [self layoutSubviews];
}

- (void)reloadWithStep:(NSInteger)step
{
    _step = step;
    [self layoutSubviews];
}

#pragma mark Private Methods

- (void)updateByStep
{
    if (self.isLightOnlyOne) {
        for (NSUInteger i = 0; i < self.numberOfStatueView; i++) {
            if (i == self.step) {
                UIView *view = self.arrayOfStatueView[i];
                view.layer.borderColor = self.colorOfStatueViewLight.CGColor;
                UIView *innerView = [view.subviews firstObject];
                innerView.backgroundColor = self.colorOfStatueViewLight;
            } else {
                UIView *view = self.arrayOfStatueView[i];
                view.layer.borderColor = self.colorOfStatueView.CGColor;
                UIView *innerView = [view.subviews firstObject];
                innerView.backgroundColor = self.colorOfStatueView;
            }
            
            if (i == self.step) {
                UILabel *label = self.arrayOfStatueTitleLabel[i];
                label.textColor = self.colorOfStatueViewLight;
            } else {
                UILabel *label = self.arrayOfStatueTitleLabel[i];
                label.textColor = self.colorOfStatueView;
            }
        }
    } else {
        for (NSUInteger i = 0; i < self.numberOfStatueView; i++) {
            if (i <= self.step) {
                UIView *view = self.arrayOfStatueView[i];
                view.layer.borderColor = self.colorOfStatueViewLight.CGColor;
                UIView *innerView = [view.subviews firstObject];
                innerView.backgroundColor = self.colorOfStatueViewLight;
            } else {
                UIView *view = self.arrayOfStatueView[i];
                view.layer.borderColor = self.colorOfStatueView.CGColor;
                UIView *innerView = [view.subviews firstObject];
                innerView.backgroundColor = self.colorOfStatueView;
            }
            
            if (i <= self.step) {
                UILabel *label = self.arrayOfStatueTitleLabel[i];
                label.textColor = self.colorOfStatueViewLight;
            } else {
                UILabel *label = self.arrayOfStatueTitleLabel[i];
                label.textColor = self.colorOfStatueView;
            }
            
            if (i != self.numberOfStatueView -1) {
                if (i < self.step) {
                    UIView *view = self.arrayOfStatueIntervalView[i];
                    view.backgroundColor = self.colorOfIntervalLight;
                } else {
                    UIView *view = self.arrayOfStatueIntervalView[i];
                    view.backgroundColor = self.colorOfInterval;
                }
            }
        }
    }
}

- (void)updateProperty
{
    [self updateNumberOfStatueView];
    [self updateColorProperty];
    [self updateFloatProperty];
}

- (void)updateFloatProperty
{
    self.lengthOfSpaceForInterval = 0;
    self.radiusOfOuterRing = 15;
    self.radiusOfInnerRing = 10;
    self.fontForTitle = 15;
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(lengthOfSpaceForInterval:)]){
        self.lengthOfSpaceForInterval = [self.delegate lengthOfSpaceForInterval:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(radiusOfOuterRing:)]){
        self.radiusOfOuterRing = [self.delegate radiusOfOuterRing:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(radiusOfInnerRing:)]){
        self.radiusOfInnerRing = [self.delegate radiusOfInnerRing:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(fontForTitle:)]){
        self.fontForTitle = [self.delegate fontForTitle:self];
    }
}

- (void)updateColorProperty
{
    switch (self.progressViewColorStyle) {
        case XMProgressViewColorStyleDefault:
        {
            self.colorOfInterval = [UIColor grayColor];
            self.colorOfStatueView = [UIColor grayColor];
            self.colorOfIntervalLight = [UIColor blueColor];
            self.colorOfStatueViewLight = [UIColor blueColor];
        }
            break;
        default:
            break;
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(colorOfInterval:)]){
        self.colorOfInterval = [self.delegate colorOfInterval:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(colorOfStatueView:)]){
        self.colorOfStatueView = [self.delegate colorOfStatueView:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(colorOfIntervalBylight:)]){
        self.colorOfIntervalLight = [self.delegate colorOfIntervalBylight:self];
    }
    if(self.delegate && [self.delegate respondsToSelector:@selector(colorOfStatueViewByLight:)]){
        self.colorOfStatueViewLight = [self.delegate colorOfStatueViewByLight:self];
    }
    
}

- (void)updateNumberOfStatueView
{
    self.numberOfStatueView = defaultNumberOfStatueView;
    if(self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfTitleData:)]){
        self.numberOfStatueView = [self.dataSource numberOfTitleData:self];
    }
}

- (void)initStatueViews
{
    for (NSUInteger i = 0; i < self.numberOfStatueView; i++) {
        UIView *view = [self creatStatueView];
        [self.arrayOfStatueView addObject:view];
    }
}

- (void)initStatueTitleLables
{
    for (NSUInteger i = 0; i < self.numberOfStatueView; i++) {
        UILabel *label = [self creatStatueTitleLabel];
        if(self.dataSource && [self.dataSource respondsToSelector:@selector(progressView:titleAtIndex:)]){
            label.text = [self.dataSource progressView:self titleAtIndex:i];
        } else {
            label.text = @"";
        }
        [self.arrayOfStatueTitleLabel addObject:label];
    }
}

- (void)initStatueIntervalView
{
    for (NSUInteger i = 0; i < self.numberOfStatueView - 1; i++) {
        UIView *view = [UIView new];
        [self.arrayOfStatueIntervalView addObject:view];
    }
}

- (UIView *)creatStatueView
{
    UIView *OuterRingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.radiusOfOuterRing, self.radiusOfOuterRing)];
    UIView *InnerRingView = [[UIView alloc] initWithFrame:CGRectMake((self.radiusOfOuterRing - self.radiusOfInnerRing)/2, (self.radiusOfOuterRing - self.radiusOfInnerRing)/2, self.radiusOfInnerRing, self.radiusOfInnerRing)];
    OuterRingView.backgroundColor = [UIColor whiteColor];
    InnerRingView.backgroundColor = self.colorOfStatueView;
    OuterRingView.layer.borderColor = self.colorOfStatueView.CGColor;
    OuterRingView.layer.borderWidth = 1;
    OuterRingView.layer.masksToBounds = YES;
    InnerRingView.layer.masksToBounds = YES;
    OuterRingView.layer.cornerRadius = CGRectGetWidth(OuterRingView.bounds) / 2;
    InnerRingView.layer.cornerRadius = CGRectGetWidth(InnerRingView.bounds) / 2;
    
    [OuterRingView addSubview:InnerRingView];
    
    return OuterRingView;
}

- (UILabel *)creatStatueTitleLabel
{
    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = self.colorOfStatueView;
    return label;
}

#pragma mark Getter/Setter

- (NSMutableArray *)arrayOfStatueView
{
    if (!_arrayOfStatueView) {
        _arrayOfStatueView = [NSMutableArray new];
    }
    return _arrayOfStatueView;
}

- (NSMutableArray *)arrayOfStatueTitleLabel
{
    if (!_arrayOfStatueTitleLabel) {
        _arrayOfStatueTitleLabel = [NSMutableArray new];
    }
    return _arrayOfStatueTitleLabel;
}

- (NSMutableArray *)arrayOfStatueIntervalView
{
    if (!_arrayOfStatueIntervalView) {
        _arrayOfStatueIntervalView = [NSMutableArray new];
    }
    return _arrayOfStatueIntervalView;
}

- (void)setStep:(NSUInteger)step;
{
    if (step < self.numberOfStatueView) {
        if (_step != step) {
            _step = step;
            [self updateByStep];
        }
    }
}

@end
