//
//  XMProgressView.h
//  XMProgress
//
//  Created by 忘忧 on 16/11/16.
//  Copyright © 2016年 小明. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XMProgressView;

typedef NS_ENUM(NSInteger, XMProgressViewStyle) {
    XMProgressViewStyleDefault,
};

typedef NS_ENUM(NSInteger, XMProgressViewColorStyle) {
    XMProgressViewColorStyleDefault,
};

@protocol XMProgressViewDelegate <NSObject>

@optional

- (CGFloat)fontForTitle:(XMProgressView *)progressView;
- (CGFloat)lengthOfSpaceForInterval:(XMProgressView *)progressView;
- (CGFloat)radiusOfOuterRing:(XMProgressView *)progressView;
- (CGFloat)radiusOfInnerRing:(XMProgressView *)progressView;
- (UIColor *)colorOfStatueView:(XMProgressView *)progressView;
- (UIColor *)colorOfInterval:(XMProgressView *)progressView;
- (UIColor *)colorOfStatueViewByLight:(XMProgressView *)progressView;
- (UIColor *)colorOfIntervalBylight:(XMProgressView *)progressView;

@end

@protocol XMProgressViewDataSource <NSObject>

@optional

- (NSInteger)numberOfTitleData:(XMProgressView *)progressView;
- (NSString *)progressView:(XMProgressView *)progressView titleAtIndex:(NSUInteger)index;

@end

@interface XMProgressView : UIView <NSObject>

@property (nonatomic, weak, nullable) id <XMProgressViewDataSource> dataSource;
@property (nonatomic, weak, nullable) id <XMProgressViewDelegate> delegate;
@property (nonatomic, assign) XMProgressViewStyle progressViewStyle;
@property (nonatomic, assign) XMProgressViewColorStyle progressViewColorStyle;
@property (nonatomic, assign) BOOL isLightOnlyOne;

- (void)reload;
- (void)reloadWithStep:(NSInteger)step;
- (void)setStep:(NSUInteger)step;

@end

NS_ASSUME_NONNULL_END
