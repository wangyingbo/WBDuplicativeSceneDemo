//
//  NSObject+Duplicative.m
//  WBStory
//
//  Created by yingbo5 on 2022/2/15.
//

#import "NSObject+Duplicative.h"
#import <objc/runtime.h>

@interface NSObject ()
@property (nonatomic, strong) NSMutableSet *scenesMutSet;
@end

@implementation NSObject (Duplicative)

- (NSMutableSet *)scenesMutSet {
    id object = objc_getAssociatedObject(self, _cmd);
    if (object && [object isKindOfClass:[NSMutableSet class]]) {
        return object;
    }
    NSMutableSet *set = [NSMutableSet set];
    if (set) {
        objc_setAssociatedObject(self, _cmd, set, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return set;
}

- (void)setScenesMutSet:(NSMutableSet *)scenesMutSet {
    objc_setAssociatedObject(self, @selector(scenesMutSet), scenesMutSet, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - WBOperationSceneProtocol
- (void)v_addScene:(NSString *)scene {
    if (![scene isKindOfClass:[NSString class]] || !scene) {
        return;
    }
    [self.scenesMutSet addObject:scene];
}

- (void)v_removeScene:(NSString *)scene {
    if (![scene isKindOfClass:[NSString class]] || !scene) {
        return;
    }
    [self.scenesMutSet removeObject:scene];
}

- (BOOL)v_containsScene:(NSString *)scene {
    if (![scene isKindOfClass:[NSString class]] || !scene) {
        return NO;
    }
    return [self.scenesMutSet containsObject:scene];
}

- (NSUInteger)v_sceneCount {
    return self.scenesMutSet.count;
}

- (void)v_removeAllScenes {
    if (self.scenesMutSet.count) {
        [self.scenesMutSet removeAllObjects];
    }
}

@end

@interface DuplicativeScene : NSObject
@property (nonatomic, copy) NSString *reason;
@property (nonatomic, strong) NSNumber *originValue;
@property (nonatomic, strong) NSNumber *lastValue;
@property (nonatomic, strong) NSNumber *currentValue;

@end

@implementation DuplicativeScene

@end

@interface UIView ()
@property (nonatomic, strong) NSObject *hiddenOperationObject;
@property (nonatomic, strong) NSObject *alpha_0_1_operationObject;
@property (nonatomic, strong) NSMutableArray *orderAlphaOperationArray;
@end

NSString * const kVideoViewHiddenReasonDefault = @"kVideoViewHiddenReasonDefault";
NSString * const kVideoViewAlphaReasonDefault = @"kVideoViewAlphaReasonDefault";

@implementation UIView (Duplicative)

#pragma mark -Associated
- (NSObject *)hiddenOperationObject {
    NSObject *object = objc_getAssociatedObject(self, _cmd);
    if (!object) {
        object = [[NSObject alloc] init];
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

- (void)setHiddenOperationObject:(NSObject *)hiddenOperationObject {
    objc_setAssociatedObject(self, @selector(hiddenOperationObject), hiddenOperationObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *)alpha_0_1_operationObject {
    NSObject *object = objc_getAssociatedObject(self, _cmd);
    if (!object) {
        object = [[NSObject alloc] init];
        objc_setAssociatedObject(self, _cmd, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return object;
}

- (void)setAlpha_0_1_operationObject:(NSObject *)alpha_0_1_operationObject {
    objc_setAssociatedObject(self, @selector(alpha_0_1_operationObject), alpha_0_1_operationObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray *)orderAlphaOperationArray {
    NSMutableArray *array = objc_getAssociatedObject(self, _cmd);
    if (![array isKindOfClass:[NSMutableArray class]]) {
        array = [NSMutableArray array];
        objc_setAssociatedObject(self, _cmd, array, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return array;
}

- (void)setOrderAlphaOperationArray:(NSMutableArray *)orderAlphaOperationArray {
    objc_setAssociatedObject(self, @selector(orderAlphaOperationArray), orderAlphaOperationArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - hidden
- (void)v_setHiddenWithReason:(NSString *)reason {
    if (!reason) {
        return;
    }
    [self.hiddenOperationObject v_addScene:reason];
    self.hidden = YES;
}

- (void)v_recoverHiddenWithReason:(NSString *)reason {
    if (!reason) {
        return;
    }
    [self.hiddenOperationObject v_removeScene:reason];
    if ([self.hiddenOperationObject v_sceneCount]) {
        return;
    }
    self.hidden = NO;
}

- (BOOL)v_containsHiddenReason:(NSString *)reason {
    return [self.hiddenOperationObject v_containsScene:reason];
}

- (NSUInteger)v_hiddenReasonCount {
    return [self.hiddenOperationObject v_sceneCount];
}

- (void)v_removeAllHiddenReasons {
    [self.hiddenOperationObject v_removeAllScenes];
}

#pragma mark - alpha 0 || 1
- (void)v_setAlpha0WithReason:(NSString *)reason {
    if (!reason) {
        return;
    }
    [self.alpha_0_1_operationObject v_addScene:reason];
    self.alpha = 0;
}

- (void)v_recoverAlpha1WithReason:(NSString *)reason {
    if (!reason) {
        return;
    }
    [self.alpha_0_1_operationObject v_removeScene:reason];
    if ([self.alpha_0_1_operationObject v_sceneCount]) {
        return;
    }
    self.alpha = 1;
}

- (BOOL)v_containsAlphaReason:(NSString *)reason {
    return [self.alpha_0_1_operationObject v_containsScene:reason];
}

- (NSUInteger)v_alphaReasonCount {
    return [self.alpha_0_1_operationObject v_sceneCount];
}

- (void)v_removeAllAlphaReasons {
    [self.alpha_0_1_operationObject v_removeAllScenes];
}

#pragma mark - order alpha
/**set the alpha in order*/
- (void)v_setOrderAlpha:(CGFloat)alpha reason:(NSString *)reason {
    if (!reason) {
        return;
    }
    __block BOOL contained = NO;
    NSInteger count = self.orderAlphaOperationArray.count;
    for (NSInteger i = 0; i < count; i++) {
        DuplicativeScene *scene = [self.orderAlphaOperationArray objectAtIndex:i];
        if (![scene isKindOfClass:[DuplicativeScene class]]) { continue; }
        if ([scene.reason isEqualToString:reason]) {
            contained = YES;
            if (!scene.originValue) {
                scene.originValue = [NSNumber numberWithFloat:self.alpha];
            }
            scene.lastValue = [NSNumber numberWithFloat:self.alpha];
            scene.currentValue = [NSNumber numberWithFloat:alpha];
            if (i != count - 1) {
                [self.orderAlphaOperationArray exchangeObjectAtIndex:i withObjectAtIndex:(count - 1)];
            }
            break;
        }
    }

    if (!contained) {
        DuplicativeScene *scene = [[DuplicativeScene alloc] init];
        scene.reason = reason;
        scene.originValue = [NSNumber numberWithFloat:self.alpha];
        scene.lastValue = [NSNumber numberWithFloat:self.alpha];
        scene.currentValue = [NSNumber numberWithFloat:alpha];
        [self.orderAlphaOperationArray addObject:scene];
    }
    self.alpha = alpha;
}

/**
 abandon method.
 recover the origin alpha according to the reason
 */
- (BOOL)v_recoverOriginAlphaReason:(NSString *)reason {
    if (!reason) {
        return NO;
    }
    __block DuplicativeScene *_scene = nil;
    __block BOOL contained = NO;
    [self.orderAlphaOperationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[DuplicativeScene class]]) { return; }
        DuplicativeScene *scene = (DuplicativeScene *)obj;
        if ([scene.reason isEqualToString:reason]) {
            contained = YES;
            _scene = scene;
            *stop = YES;
        }
    }];
    if (contained && _scene) {
        self.alpha = _scene.originValue.floatValue;
        [self.orderAlphaOperationArray removeObject:_scene];
        return YES;
    }
    return NO;
}

/**remove the reason and recover the origin alpha if the reason is last one.*/
- (BOOL)v_removeAlphaWithReason:(NSString *)reason {
    if (!reason) {
        return NO;
    }
    DuplicativeScene *lastScene = [self.orderAlphaOperationArray lastObject];
    if (!lastScene || ![lastScene isKindOfClass:[DuplicativeScene class]]) {
        return NO;
    }
    if ([reason isEqualToString:lastScene.reason]) {
        self.alpha = lastScene.originValue.floatValue;
        [self.orderAlphaOperationArray removeLastObject];
        return YES;
    }
    
    __block BOOL contained = NO;
    __block NSInteger index = -1;
    [self.orderAlphaOperationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isKindOfClass:[DuplicativeScene class]]) { return; }
        DuplicativeScene *scene = (DuplicativeScene *)obj;
        if ([scene.reason isEqualToString:reason]) {
            contained = YES;
            index = idx;
            *stop = YES;
        }
    } ];
    if (contained && index >= 0) {
        [self.orderAlphaOperationArray removeObjectAtIndex:index];
        return YES;
    }
    
    return NO;
}

@end
