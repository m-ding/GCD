//
//  CoverView.m
//  多线程
//
//  Created by myk on 2023/4/21.
//

#import "CoverView.h"

@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    UIButton *btn = [UIButton.alloc initWithFrame:CGRectMake(10, 30, 88, 33)];
    btn.backgroundColor = [UIColor blueColor];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [UIButton.alloc initWithFrame:CGRectMake(10, 80, 88, 33)];
    btn2.backgroundColor = [UIColor blueColor];
    [self addSubview:btn2];
    [btn2 addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    NSLog(@"点击");
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
        NSLog(@"5s之后");
        dispatch_semaphore_signal(sema);
    });
    
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    NSLog(@"---结束");
}
@end
