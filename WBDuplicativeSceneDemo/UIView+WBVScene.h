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
@required
- (NSString *)scene;
- (NSUInteger)priority;
@optional
- (NSValue *)sceneValue;
- (NSNumber *)numberValue;

@end

@interface WBVDuplicativeScene : NSObject<WBVDuplicativeSceneProtocol>
@property (nonatomic, copy) NSString *scene;
@property (nonatomic, assign) NSUInteger priority;
@property (nonatomic, strong) NSValue *sceneValue;
@property (nonatomic, strong) NSNumber *numberValue;
@end

@interface WBOperationObject : NSObject
- (void)wbv_addSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (void)wbv_removeSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHighestSceneObject;
- (NSUInteger)wbv_scenesCount;
- (BOOL)wbv_containsSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject;
- (void)wbv_removeAllSceneObjects;

@end

@interface UIView (WBVScene)
/**
 默认priority值：WBDuplicativeScenePriorityMedium
 */
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason;
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason priority:(NSUInteger)priority;
- (void)wbv_removeHiddenReason:(NSString *)reason;
- (WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)wbv_currentSceneObject;
- (void)wbv_removeAllHiddenReasons;
- (BOOL)wbv_containsHiddenReason:(NSString *)reason;

@end

NS_ASSUME_NONNULL_END
