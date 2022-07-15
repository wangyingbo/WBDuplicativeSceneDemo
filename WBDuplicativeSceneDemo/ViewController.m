//
//  ViewController.m
//  WBDuplicativeSceneDemo
//
//  Created by yingbo5 on 2022/6/15.
//

#import "ViewController.h"
#import "UIView+WBVScene.h"
#import "NSString+WBStory.h"

@interface ViewController ()
@property (nonatomic, strong) UIView *redView;
@end


static NSString * const RedViewHiddenReasonFirst = @"RedViewHiddenReasonFirst";
static NSString * const RedViewHiddenReasonSecond = @"RedViewHiddenReasonSecond";


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setButtons];
    
    [self setupSubviews];
}

#pragma mark - init UI

- (void)setButtons {
    CGFloat button_w = 80.f;
    CGFloat button_h = 44.f;
    CGFloat leftMargin = 50.f;
    CGFloat rightMargin = leftMargin;
    CGFloat topMargin = 100.f;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, button_w, button_h)];
    [leftButton setTitle:@"left" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - button_w - rightMargin, topMargin, button_w, button_h)];
    [rightButton setTitle:@"right" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    [rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupSubviews {
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(20.f, 200.f, 35.f, 35.f)];
    redView.backgroundColor = [UIColor redColor];
    [self.view addSubview:redView];
    self.redView = redView;
}


#pragma mark - actions

- (void)leftButtonClick:(id)sender {
    if ([self.redView wbv_containsHiddenReason:RedViewHiddenReasonFirst]) {
        [self.redView wbv_removeHiddenReason:RedViewHiddenReasonFirst];
    }else {
        [self.redView wbv_setHidden:YES reason:RedViewHiddenReasonFirst priority:WBDuplicativeScenePriorityMedium];
    }
    NSLog(@"%@",[self.redView wbv_allHiddenReasonsAndPriorities]);
    [self testAsciiString];
}

- (void)rightButtonClick:(id)sender {
    if ([self.redView wbv_containsHiddenReason:RedViewHiddenReasonSecond]) {
        [self.redView wbv_removeHiddenReason:RedViewHiddenReasonSecond];
    }else {
        [self.redView wbv_setHidden:NO reason:RedViewHiddenReasonSecond priority:WBDuplicativeScenePriorityMedium];
    }
    NSLog(@"%@",[self.redView wbv_allHiddenReasonsAndPriorities]);
}

#pragma mark - actions

- (void)testAsciiString {
    NSString *nameStr = @"wb微博技术开发视频开发";
    if (nameStr) {
        NSInteger maxLengh = 6;
        NSString *suffix = @"";
        if ([nameStr wbt_wordCount] > maxLengh) {
            suffix = @"...";
        }
        NSString *tempNameStr = [nameStr wbst_stringWithMaxWordCount:maxLengh];
        if (tempNameStr) {
            nameStr = [tempNameStr stringByAppendingString:suffix];
        }
        NSLog(@"%@",nameStr);
    }
}

@end
