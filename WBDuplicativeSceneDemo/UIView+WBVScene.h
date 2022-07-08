//
//  UIView+WBVScene.h
//  WBDuplicativeSceneDemo
//
//  Created by yingbo5 on 2022/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSUInteger const WBDuplicativeScenePriorityHigh;
FOUNDATION_EXTERN NSUInteger const WBDuplicativeScenePriorityMedium;
FOUNDATION_EXTERN NSUInteger const WBDuplicativeScenePriorityLow;

@protocol WBVDuplicativeSceneProtocol <NSObject>
/// 操作场景描述
@property (nonatomic, copy) NSString *scene;
/// 操作场景权重
@property (nonatomic, assign) NSUInteger priority;
/// 操作的值，可以是alpha、hidden等，用来透传和记录
@property (nonatomic, strong) id userInfo;
@end

@interface WBVDuplicativeScene : NSObject<WBVDuplicativeSceneProtocol>

@end

@interface WBOperationObject : NSObject
- (void)wbv_addSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (void)wbv_removeSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHighestSceneObject;
- (NSUInteger)wbv_scenesCount;
- (BOOL)wbv_containsSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (NSArray<NSObject<WBVDuplicativeSceneProtocol> *> *)wbv_allSceneObjects;
- (void)wbv_removeAllSceneObjects;
@end

@interface UIView (WBVScene)

#pragma mark - hidden public methods

/**
 默认priority值：WBDuplicativeScenePriorityMedium，一般使用此方法设置hidden，reason具有唯一性。
 */
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason;
/**
 可以设置权重来设置hidden，内部会根据权重从大到小排序，以权重最高的reason的操作为实际设置hidden的效果，如果权重设置的比默认的WBDuplicativeScenePriorityMedium高，则一定要调用-wbv_removeHiddenReason:方法移除自己设置的的reason。
 */
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason priority:(NSUInteger)priority;
/**
 移除某一reason，移除后会把当前hidden设置成所有reason中权重最高的那个，如果移除后不存在reason，会恢复原值。
 */
- (void)wbv_removeHiddenReason:(NSString *)reason;
/**
 查看当前权重最高的设置hidden的reason和权重。
 */
- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHiddenPriorityHighestSceneObject;
/**
 用来查看当前所有的hidden相关的reason和priority。
 */
- (NSDictionary<NSString *,NSNumber *> *)wbv_allHiddenReasonsAndPriorities;
/**
 移除所有的reasons，移除成功后如果记录的有原值，会恢复成原值。
 */
- (void)wbv_removeAllHiddenReasons;
/**
 判断是否包含某个reason。
 */
- (BOOL)wbv_containsHiddenReason:(NSString *)reason;
/**
 当前hidden操作中reason的数量。
 */
- (NSUInteger)wbv_hiddenReasonCount;

@end

NS_ASSUME_NONNULL_END
