//
//  UIView+WBSVIndicator.h
//  WBStory
//
//  Created by yingbo5 on 2022/7/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**旋转部分颜色*/
FOUNDATION_EXTERN NSString * const WBSVideoViewIndicatorAttributesIndicatorColor;
/**背景颜色*/
FOUNDATION_EXTERN NSString * const WBSVideoViewIndicatorAttributesIndicatorBackgroundColor;
/**暂停旋转时是否隐藏 value is number type*/
FOUNDATION_EXTERN NSString * const WBSVideoViewIndicatorAttributesIndicatorHidesWhenStopped;
/**缩放比例 value is number type*/
FOUNDATION_EXTERN NSString * const WBSVideoViewIndicatorAttributesIndicatorScale;

/**
 系统提供的style生成的默认indicatorView的size
 UIActivityIndicatorViewStyleWhiteLarge  大小是（37，37）
 UIActivityIndicatorViewStyleWhite  大小是（22，22）
 UIActivityIndicatorViewStyleGray   大小是（22，22）
 */
@interface UIView (WBSVIndicator)

/// 启动indicator指示器并开始动画，iOS13以上style为UIActivityIndicatorViewStyleMedium，iOS13以下为UIActivityIndicatorViewStyleWhite
- (void)sv_startAnimating;

/// 只传入系统给的style类型，indicator大小根据传入的style值是固定的
/// @param style style description
- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style;

/// 修改indicator颜色和缩放大小比例的方法
/// @param style style description
/// @param indicatorColor 指示器颜色
/// @param scaleRatio 指示器缩放比例，会调用CGAffineTransformMakeScale对indicatorView进行缩放
- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style indicatorColor:(nullable UIColor *)indicatorColor scaleRatio:(nullable NSNumber *)scaleRatio;

/// 全量方法，可通过key:value形式改变indicator的相关属性
/// @param style 类型
/// @param extraParams 修改indicator的相关属性
- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style extraParams:(nullable NSDictionary *)extraParams;

/// 停止转指示器，HidesWhenStopped 默认为YES
- (void)sv_stopAnimating;

/// 当前指示器的动画状态
- (BOOL)sv_isAnimating;
@end

NS_ASSUME_NONNULL_END
