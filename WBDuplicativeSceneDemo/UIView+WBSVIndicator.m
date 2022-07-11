//
//  UIView+WBSVIndicator.m
//  WBStory
//
//  Created by yingbo5 on 2022/7/5.
//

#import "UIView+WBSVIndicator.h"
#import <objc/runtime.h>


@interface UIView ()
@property (nonatomic, strong) UIActivityIndicatorView *sv_indicatorView;
@end

NSString * const WBSVideoViewIndicatorAttributesIndicatorColor = @"WBSVideoViewIndicatorAttributesIndicatorColor";
NSString * const WBSVideoViewIndicatorAttributesIndicatorBackgroundColor = @"WBSVideoViewIndicatorAttributesIndicatorBackgroundColor";
NSString * const WBSVideoViewIndicatorAttributesIndicatorHidesWhenStopped = @"WBSVideoViewIndicatorAttributesIndicatorHidesWhenStopped";
NSString * const WBSVideoViewIndicatorAttributesIndicatorScale = @"WBSVideoViewIndicatorAttributesIndicatorScale";


@implementation UIView (WBSVIndicator)

#pragma mark -Associated

- (UIActivityIndicatorView *)sv_indicatorView {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setSv_indicatorView:(UIActivityIndicatorView *)sv_indicatorView {
    objc_setAssociatedObject(self, @selector(sv_indicatorView), sv_indicatorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public
- (void)sv_startAnimating {
    if (@available(iOS 13.0, *)) {
        [self sv_startAnimatingWithStyle:UIActivityIndicatorViewStyleMedium];
    }else {
        [self sv_startAnimatingWithStyle:UIActivityIndicatorViewStyleWhite];
    }
}

- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style {
    [self sv_startAnimatingWithStyle:style indicatorColor:nil scaleRatio:nil];
}

- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style indicatorColor:(nullable UIColor *)indicatorColor scaleRatio:(nullable NSNumber *)scaleRatio {
    NSMutableDictionary *extraParams = [NSMutableDictionary dictionary];
    if (indicatorColor && [indicatorColor isKindOfClass:[UIColor class]]) {
        [extraParams setObject:indicatorColor forKey:WBSVideoViewIndicatorAttributesIndicatorColor];
    }
    if (scaleRatio && [scaleRatio isKindOfClass:[NSNumber class]]) {
        [extraParams setObject:scaleRatio forKey:WBSVideoViewIndicatorAttributesIndicatorScale];
    }
    [self sv_startAnimatingWithStyle:style extraParams:[extraParams copy]];
}

- (void)sv_startAnimatingWithStyle:(UIActivityIndicatorViewStyle)style extraParams:(NSDictionary *)extraParams {
    if (![extraParams isKindOfClass:[NSDictionary class]]) {
        extraParams = [NSDictionary dictionary];
    }
    if (!self.sv_indicatorView) {
        UIActivityIndicatorView *sv_indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
        sv_indicatorView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
        [self addSubview:sv_indicatorView];
        self.sv_indicatorView = sv_indicatorView;
        
        /**indicator attributes*/
        
        UIColor *indicatorColor = [extraParams objectForKey:WBSVideoViewIndicatorAttributesIndicatorColor];
        if ([indicatorColor isKindOfClass:[UIColor class]]) {
            sv_indicatorView.color = indicatorColor;
        }
        UIColor *indicatorBackgroundColor = [extraParams objectForKey:WBSVideoViewIndicatorAttributesIndicatorBackgroundColor];
        if ([indicatorBackgroundColor isKindOfClass:[UIColor class]]) {
            sv_indicatorView.backgroundColor = indicatorBackgroundColor;
        }
        NSNumber *indicatorHidesWhenStopped = [extraParams objectForKey:WBSVideoViewIndicatorAttributesIndicatorHidesWhenStopped];
        if ([indicatorHidesWhenStopped isKindOfClass:[NSNumber class]]) {
            sv_indicatorView.hidesWhenStopped = [indicatorHidesWhenStopped boolValue];
        }
        NSNumber *scaleNum = [extraParams objectForKey:WBSVideoViewIndicatorAttributesIndicatorScale];
        if ([scaleNum isKindOfClass:[NSNumber class]]) {
            CGFloat scale = [scaleNum floatValue];
            sv_indicatorView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    }
    [self.sv_indicatorView startAnimating];
}

- (void)sv_stopAnimating {
    [self.sv_indicatorView stopAnimating];
    [self.sv_indicatorView removeFromSuperview];
    self.sv_indicatorView = nil;
}

- (BOOL)sv_isAnimating {
    return [self.sv_indicatorView isAnimating];
}


@end
