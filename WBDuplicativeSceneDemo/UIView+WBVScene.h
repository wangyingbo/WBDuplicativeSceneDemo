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
/// 操作权重
@property (nonatomic, assign) NSUInteger priority;
/// 操作的值
@property (nonatomic, strong) NSNumber *numberValue;
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
/**
 默认priority值：WBDuplicativeScenePriorityMedium，一般使用此方法。
 */
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason;
/**
 可以设置权重来设置hidden，内部会根据权重从大到小排序，以权重最高的reason的操作为实际设置hidden的效果，如果权重设置的比默认的WBDuplicativeScenePriorityMedium高，则一定要有调用-wbv_removeHiddenReason:的方法移除权重高的reason。
 */
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason priority:(NSUInteger)priority;
- (void)wbv_removeHiddenReason:(NSString *)reason;
/**查看当前权重最高的设置hidden的reason和权重*/
- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHiddenPriorityHighestSceneObject;
- (void)wbv_removeAllHiddenReasons;
/**用来查看当前所有的hidden相关的reason和priority*/
- (NSDictionary<NSString *,NSNumber *> *)wbv_allHiddenReasonsAndPriorities;
- (BOOL)wbv_containsHiddenReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
