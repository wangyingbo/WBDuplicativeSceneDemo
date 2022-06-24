//
//  UIView+WBVScene.m
//  WBDuplicativeSceneDemo
//
//  Created by yingbo5 on 2022/6/15.
//

#import "UIView+WBVScene.h"
#import <objc/runtime.h>

static NSInteger const WBDuplicativeSceneInitialValue = -1;
NSUInteger const WBDuplicativeScenePriorityHigh = 750;
NSUInteger const WBDuplicativeScenePriorityMedium = 500;
NSUInteger const WBDuplicativeScenePriorityLow = 250;

@implementation WBVDuplicativeScene
@synthesize scene = _scene;
@synthesize priority = _priority;
@synthesize numberValue = _numberValue;
@end

@interface WBOperationObject ()
@property (nonatomic, strong) NSMutableArray *scenesMutArray;
@end

@implementation WBOperationObject

- (NSMutableArray *)scenesMutArray {
    if (!_scenesMutArray) {
        _scenesMutArray = [NSMutableArray array];
    }
    return _scenesMutArray;
}

- (void)wbv_addSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (![sceneObject conformsToProtocol:@protocol(WBVDuplicativeSceneProtocol)]) {
        return;
    }
    if (!self.scenesMutArray.count) {
        [self.scenesMutArray addObject:sceneObject];
        return;
    }
    __block NSInteger insertIndex = WBDuplicativeSceneInitialValue;
    __block NSInteger replaceIndex = WBDuplicativeSceneInitialValue;
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        NSObject<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
        if ([sceneObject.scene isEqualToString:object.scene] && replaceIndex == WBDuplicativeSceneInitialValue) {
            replaceIndex = i;
            break;
        }
        if (sceneObject.priority >= object.priority && insertIndex == WBDuplicativeSceneInitialValue) {
            insertIndex = i;
        }
    }
    if (replaceIndex > WBDuplicativeSceneInitialValue) {
        [self.scenesMutArray replaceObjectAtIndex:replaceIndex withObject:sceneObject];
        [self _sortArrayDescending];
    }else if (insertIndex > WBDuplicativeSceneInitialValue) {
        [self.scenesMutArray insertObject:sceneObject atIndex:insertIndex];
    }else {
        [self.scenesMutArray addObject:sceneObject];
    }
}

- (void)wbv_removeSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (![sceneObject conformsToProtocol:@protocol(WBVDuplicativeSceneProtocol)]) {
        return;
    }
    if (!self.scenesMutArray.count) {
        return;
    }
    __block NSInteger removeIndex = WBDuplicativeSceneInitialValue;
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        NSObject<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
        if ([sceneObject.scene isEqualToString:object.scene] && removeIndex == WBDuplicativeSceneInitialValue) {
            removeIndex = i;
            break;
        }
    }
    if (removeIndex > WBDuplicativeSceneInitialValue) {
        [self.scenesMutArray removeObjectAtIndex:removeIndex];
    }
}

/// 从大到小排序
- (void)_sortArrayDescending {
    [self.scenesMutArray sortedArrayUsingComparator:^NSComparisonResult(NSObject<WBVDuplicativeSceneProtocol> * _Nonnull obj1, NSObject<WBVDuplicativeSceneProtocol> * _Nonnull obj2) {
        if (obj1.priority < obj2.priority) {
            return NSOrderedDescending;
        }else if (obj1.priority == obj2.priority) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
}

- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHighestSceneObject {
    if (!self.scenesMutArray.count) {
        return nil;
    }
    return [self.scenesMutArray firstObject];
}

- (NSUInteger)wbv_scenesCount {
    return [self.scenesMutArray count];
}

- (BOOL)wbv_containsSceneObject:(NSObject<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (!self.scenesMutArray.count) {
        return NO;
    }
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        NSObject<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
        if ([sceneObject.scene isEqualToString:object.scene]) {
            return YES;
        }
    }
    return NO;
}

- (NSArray<NSObject<WBVDuplicativeSceneProtocol> *> *)wbv_allSceneObjects {
    return [self.scenesMutArray copy];
}

- (void)wbv_removeAllSceneObjects {
    [self.scenesMutArray removeAllObjects];
}

@end

@interface UIView ()
/// 操作hidden的object
@property (nonatomic, strong) WBOperationObject *hiddenOperation;
/// 记录操作前的原始值
@property (nonatomic, strong) NSNumber *oriHiddenBeforeOperation;
@end

@implementation UIView (WBVScene)

#pragma mark -Associated

- (WBOperationObject *)hiddenOperation {
    WBOperationObject *object = objc_getAssociatedObject(self, _cmd);
    if (object && [object isKindOfClass:[WBOperationObject class]]) {
        return object;
    }
    object = [[WBOperationObject alloc] init];
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return object;
}

- (void)setHiddenOperation:(WBOperationObject *)hiddenOperation {
    objc_setAssociatedObject(self, @selector(hiddenOperation), hiddenOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSNumber *)oriHiddenBeforeOperation {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setOriHiddenBeforeOperation:(NSNumber *)oriHiddenBeforeOperation {
    objc_setAssociatedObject(self, @selector(oriHiddenBeforeOperation), oriHiddenBeforeOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - universal methods

/// 给operation添加操作的scene，并记录操作前的原始值
/// @param operation 操作对象
/// @param numberValue 需要操作的值
/// @param reason 操作的场景
/// @param priority 权重
/// @param originNumberValue 保存原始值的对象
+ (BOOL)_operation:(WBOperationObject *)operation setNumberValue:(NSNumber *)numberValue reason:(NSString *)reason priority:(NSUInteger)priority originNumberValue:(NSNumber *)originNumberValue {
    if (!operation) { return NO; }
    if (!reason) { return NO; }
    if (!numberValue) { return NO; }
    //添加reason之前记录原始值
    if (![operation wbv_scenesCount]) {
        originNumberValue = numberValue;
    }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    currentSceneObject.priority = priority;
    currentSceneObject.numberValue = numberValue;
    [operation wbv_addSceneObject:currentSceneObject];
    return YES;
}

/// 找出最高权重的scene里的numberValue
/// @param operation operation description
+ (NSNumber *)_numberValueInHighestPrioritySceneObjectWithOperation:(WBOperationObject *)operation {
    if (!operation) { return nil; }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *highestPrioritySceneObject = (WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)[operation wbv_currentHighestSceneObject];
    if (![highestPrioritySceneObject isKindOfClass:[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> class]]) {
        return nil;
    }
    if (![highestPrioritySceneObject conformsToProtocol:@protocol(WBVDuplicativeSceneProtocol)]) {
        return nil;
    }
    if (![highestPrioritySceneObject respondsToSelector:@selector(numberValue)]) {
        return nil;
    }
    return highestPrioritySceneObject.numberValue;
}

/// 移除操作中的某个场景
/// @param operation operation description
/// @param reason 需要移除的场景
+ (BOOL)_operation:(WBOperationObject *)operation removeReason:(NSString *)reason {
    if (!operation) { return NO; }
    if (!reason) { return NO; }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    if (![operation wbv_containsSceneObject:currentSceneObject]) {
        return NO;
    }
    [operation wbv_removeSceneObject:currentSceneObject];
    return YES;
}

/// 找到在当前所有操作中权重最高的场景
/// @param operation operation description
+ (NSObject<WBVDuplicativeSceneProtocol> *)_currentPriorityHighestSceneObjectWithOperation:(WBOperationObject *)operation {
    if (!operation) { return nil; }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *highestPrioritySceneObject = (WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)[operation wbv_currentHighestSceneObject];
    if (![highestPrioritySceneObject isKindOfClass:[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> class]]) {
        return nil;
    }
    if (![highestPrioritySceneObject conformsToProtocol:@protocol(WBVDuplicativeSceneProtocol)]) {
        return nil;
    }
    return highestPrioritySceneObject;
}

/// 列出所有的操作场景
/// @param operation operation description
+ (NSDictionary<NSString *,NSNumber *> *)_allHiddenReasonsAndPrioritiesWithOperation:(WBOperationObject *)operation {
    NSMutableDictionary *mutDict = [NSMutableDictionary dictionary];
    if (!operation) { return [mutDict copy]; }
    NSArray<NSObject<WBVDuplicativeSceneProtocol> *> *sceneObjects = [operation wbv_allSceneObjects];
    if (!sceneObjects.count) {
        return [mutDict copy];
    }
    for (NSObject<WBVDuplicativeSceneProtocol> *sceneObject in sceneObjects) {
        if ([sceneObject scene]) {
            [mutDict setObject:[NSNumber numberWithInteger:[sceneObject priority]] forKey:[sceneObject scene]];
        }
    }
    return [mutDict copy];
}

/// 当前所有的操作场景中，是否包含某一个场景
/// @param operation operation description
/// @param reason 某一个场景
+ (BOOL)_operation:(WBOperationObject *)operation containsReason:(NSString *)reason {
    if (!operation) { return NO; }
    if (!reason) { return NO; }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    return [operation wbv_containsSceneObject:currentSceneObject];
}

/// 移除操作中所有的场景
/// @param operation operation description
+ (BOOL)_operationRemoveAllReasons:(WBOperationObject *)operation {
    if (!operation) { return NO; }
    [operation wbv_removeAllSceneObjects];
    return YES;
}

#pragma mark - hidden public method

- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason {
    [self wbv_setHidden:hidden reason:reason priority:WBDuplicativeScenePriorityMedium];
}
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason priority:(NSUInteger)priority {
    if (!reason) { return; }
    BOOL _setHidden = [UIView _operation:self.hiddenOperation setNumberValue:[NSNumber numberWithBool:hidden] reason:reason priority:priority originNumberValue:self.oriHiddenBeforeOperation];
    if (!_setHidden) { return; }
    //添加新的场景后，设置成当前最高权重操作的值
    [self _setHiddenWithPriorityHighScene];
}

- (void)wbv_removeHiddenReason:(NSString *)reason {
    if (!reason) { return; }
    BOOL _removeReason = [UIView _operation:self.hiddenOperation removeReason:reason];
    if (!_removeReason) { return; }
    //移除某个场景后，设置成当前最高权重操作的值
    BOOL _setHighest = [self _setHiddenWithPriorityHighScene];
    if (!_setHighest) { return; }
    //移除所有reason之后恢复原始值
    [self _recoverOriginHiddenStateIfNeed];
}

- (NSObject<WBVDuplicativeSceneProtocol> *)wbv_currentHiddenPriorityHighestSceneObject {
    return [UIView _currentPriorityHighestSceneObjectWithOperation:self.hiddenOperation];
}

- (void)wbv_removeAllHiddenReasons {
    BOOL _removeAll = [UIView _operationRemoveAllReasons:self.hiddenOperation];
    if (!_removeAll) { return; }
    //移除所有reason之后恢复原始值
    [self _recoverOriginHiddenStateIfNeed];
}

- (NSDictionary<NSString *,NSNumber *> *)wbv_allHiddenReasonsAndPriorities {
    return [UIView _allHiddenReasonsAndPrioritiesWithOperation:self.hiddenOperation];
}

- (BOOL)wbv_containsHiddenReason:(NSString *)reason {
    return [UIView _operation:self.hiddenOperation containsReason:reason];
}

#pragma mark - hidden private method

- (BOOL)_setHiddenWithPriorityHighScene {
    NSNumber *valNumber = [UIView _numberValueInHighestPrioritySceneObjectWithOperation:self.hiddenOperation];
    if (!valNumber) { return NO; }
    BOOL _hidden = [valNumber boolValue];
    if (self.hidden ^ _hidden) {
        self.hidden = _hidden;
    }
    return YES;
}

/// 如果所有的场景都被清空了，且记录了原始值，会恢复成原始值
- (BOOL)_recoverOriginHiddenStateIfNeed {
    if ([self.hiddenOperation wbv_scenesCount]) {
        return NO;
    }
    if (!self.oriHiddenBeforeOperation) {
        return NO;
    }
    BOOL _hidden = [self.oriHiddenBeforeOperation boolValue];
    if (self.hidden ^ _hidden) {
        self.hidden = _hidden;
    }
    self.oriHiddenBeforeOperation = nil;
    return YES;
}

@end
