//
//  UIView+WBVScene.m
//  WBDuplicativeSceneDemo
//
//  Created by yingbo5 on 2022/6/15.
//

#import "UIView+WBVScene.h"
#import <objc/runtime.h>

static NSInteger const WBDuplicativeSceneInitialValue = -1;
@implementation WBVDuplicativeScene

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

- (void)wbv_addSceneObject:(WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (![sceneObject isKindOfClass:WBVDuplicativeScene.class]) {
        return;
    }
    if (!self.scenesMutArray.count) {
        [self.scenesMutArray addObject:sceneObject];
        return;
    }
    __block NSInteger insertIndex = WBDuplicativeSceneInitialValue;
    __block NSInteger replaceIndex = WBDuplicativeSceneInitialValue;
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
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

- (void)wbv_removeSceneObject:(WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (![sceneObject isKindOfClass:WBVDuplicativeScene.class]) {
        return;
    }
    if (!self.scenesMutArray.count) {
        return;
    }
    __block NSInteger removeIndex = WBDuplicativeSceneInitialValue;
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
        if ([sceneObject.scene isEqualToString:object.scene] && removeIndex == WBDuplicativeSceneInitialValue) {
            removeIndex = i;
            break;
        }
    }
    if (removeIndex > WBDuplicativeSceneInitialValue) {
        [self.scenesMutArray removeObjectAtIndex:removeIndex];
    }
}

- (void)_sortArrayDescending {
    [self.scenesMutArray sortedArrayUsingComparator:^NSComparisonResult(WBVDuplicativeScene<WBVDuplicativeSceneProtocol>   * _Nonnull obj1, WBVDuplicativeScene<WBVDuplicativeSceneProtocol>  * _Nonnull obj2) {
        if (obj1.priority < obj2.priority) {
            return NSOrderedDescending;
        }else if (obj1.priority == obj2.priority) {
            return NSOrderedSame;
        } else {
            return NSOrderedAscending;
        }
    }];
}

- (WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)wbv_priorityHighSceneObject {
    if (!self.scenesMutArray.count) {
        return nil;
    }
    return [self.scenesMutArray firstObject];
}

- (NSUInteger)wbv_scenesCount {
    return [self.scenesMutArray count];
}

- (BOOL)wbv_containsSceneObject:(WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)sceneObject {
    if (!self.scenesMutArray.count) {
        return NO;
    }
    for (NSUInteger i = 0; i < self.scenesMutArray.count; i++) {
        WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *object = [self.scenesMutArray objectAtIndex:i];
        if ([sceneObject.scene isEqualToString:object.scene]) {
            return YES;
        }
    }
    return NO;
}

- (void)wbv_removeAllSceneObjects {
    [self.scenesMutArray removeAllObjects];
}

@end

@interface UIView ()
@property (nonatomic, strong) WBOperationObject *hiddenOperation;
@end

@implementation UIView (WBVScene)

#pragma mark -Associated
- (NSObject *)hiddenOperation {
    NSObject *object = objc_getAssociatedObject(self, _cmd);
    if (object && [object isKindOfClass:[NSObject class]]) {
        return object;
    }
    object = [[NSObject alloc] init];
    objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return object;
}

- (void)setHiddenOperation:(NSObject *)hiddenOperation {
    objc_setAssociatedObject(self, @selector(hiddenOperation), hiddenOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - public
- (void)wbv_setHidden:(BOOL)hidden reason:(NSString *)reason priority:(NSUInteger)priority {
    if (!reason) {
        return;
    }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    currentSceneObject.priority = priority;
    currentSceneObject.numberValue = [NSNumber numberWithBool:hidden];
    [self.hiddenOperation wbv_addSceneObject:currentSceneObject];
    
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *priorityHighSceneObject = [self.hiddenOperation wbv_priorityHighSceneObject];
    if (priorityHighSceneObject) {
        self.hidden = [priorityHighSceneObject.numberValue boolValue];
    }
}

- (void)wbv_removeHiddenReason:(NSString *)reason {
    if (!reason) {
        return;
    }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    [self.hiddenOperation wbv_removeSceneObject:currentSceneObject];
}

- (WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *)wbv_currentSceneObject {
    return [self.hiddenOperation wbv_priorityHighSceneObject];
}

- (void)wbv_removeAllHiddenReasons {
    [self.hiddenOperation wbv_removeAllSceneObjects];
}

- (BOOL)wbv_containsHiddenReason:(NSString *)reason {
    if (!reason) {
        return NO;
    }
    WBVDuplicativeScene<WBVDuplicativeSceneProtocol> *currentSceneObject = [[WBVDuplicativeScene<WBVDuplicativeSceneProtocol> alloc] init];
    currentSceneObject.scene = reason;
    return [self.hiddenOperation wbv_containsSceneObject:currentSceneObject];
}

@end
