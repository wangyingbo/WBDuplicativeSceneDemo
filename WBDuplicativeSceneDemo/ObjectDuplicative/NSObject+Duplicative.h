//
//  NSObject+Duplicative.h
//  WBStory
//
//  Created by yingbo5 on 2022/2/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol WBOperationSceneProtocol <NSObject>

@end

NS_ASSUME_NONNULL_BEGIN
/**针对一些不同场景调用同一方法时，区分场景值*/
@interface NSObject (Duplicative)<WBOperationSceneProtocol>
- (void)v_addScene:(NSString *)scene;
- (void)v_removeScene:(NSString *)scene;
- (BOOL)v_containsScene:(NSString *)scene;
- (NSUInteger)v_sceneCount;
- (void)v_removeAllScenes;
@end

extern NSString * const kVideoViewHiddenReasonDefault;
extern NSString * const kVideoViewAlphaReasonDefault;

@interface UIView (Duplicative)

#pragma mark - hidden
/**set hidden to YES*/
- (void)v_setHiddenWithReason:(NSString *)reason;
/**recover hidden to NO if could*/
- (void)v_recoverHiddenWithReason:(NSString *)reason;
- (BOOL)v_containsHiddenReason:(NSString *)reason;
- (NSUInteger)v_hiddenReasonCount;
- (void)v_removeAllHiddenReasons;

#pragma mark - alpha 0 || 1
/**set alpha to 0*/
- (void)v_setAlpha0WithReason:(NSString *)reason;
/**recover alpha to 1 if could*/
- (void)v_recoverAlpha1WithReason:(NSString *)reason;
- (BOOL)v_containsAlphaReason:(NSString *)reason;
- (NSUInteger)v_alphaReasonCount;
- (void)v_removeAllAlphaReasons;

#pragma mark - order alpha
/**set the alpha in order*/
- (void)v_setOrderAlpha:(CGFloat)alpha reason:(NSString *)reason;
/**remove the reason and recover the origin alpha if the reason is last one.*/
- (BOOL)v_removeAlphaWithReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
