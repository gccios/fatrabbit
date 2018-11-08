//
//  FRTabbar.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/20.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRTabbar.h"
#import "FRCateListViewController.h"
#import "FRPublishNeedController.h"

@interface FRTabbar () <FRCateListViewControllerDelegate>

@property (nonatomic, strong) UIView * centerView;
@property (nonatomic, strong) UIButton * centerButton;
@property (nonatomic, strong) UILabel * titleLabel;

@end

@implementation FRTabbar

- (instancetype)init
{
    if (self = [super init]) {
        [self createTabBar];
    }
    return self;
}

- (void)createTabBar
{
    self.translucent = NO;
    self.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self addSubview:self.centerView];
    
    self.centerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.centerButton.frame = self.centerView.frame;
    [self.centerView addSubview:self.centerButton];
    self.centerButton.layer.cornerRadius = self.centerButton.frame.size.width / 2.f;
    self.centerButton.layer.masksToBounds = YES;
    [self.centerButton setBackgroundImage:[UIImage imageNamed:@"homeAdd"] forState:UIControlStateNormal];
    [self.centerView addSubview:self.centerButton];
    [self.centerButton addTarget:self action:@selector(centerButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 15)];
    self.titleLabel.textColor = UIColorFromRGB(0x333333);
    self.titleLabel.font = kPingFangRegular(11);
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"发布";
    [self addSubview:self.titleLabel];
}

- (void)centerButtonDidClicked
{
    UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * na = (UINavigationController *)tab.selectedViewController;
    FRCateListViewController * vc = [[FRCateListViewController alloc] initWithType:FRCateListType_Publish];
    vc.delegate = self;
    [na presentViewController:vc animated:YES completion:nil];
}

#pragma mark - FRCateListViewControllerDelegate
- (void)FRcateListViewCongtrollerDidChoose:(FRCateModel *)model type:(FRCateListType)type
{
    UITabBarController * tab = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController * na = (UINavigationController *)tab.selectedViewController;
    
    FRPublishNeedController * need = [[FRPublishNeedController alloc] initWithFRCateModel:model];
    [na pushViewController:need animated:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    
    NSInteger index = 0;
    
    CGFloat width = self.frame.size.width / (count + 1);
    CGFloat height = self.frame.size.height;
    
    if (KIsiPhoneX) {
        height -= 34;
    }
    
    // 遍历所有按钮, 调整按钮位置
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            // 当遇到第三个按钮(标记是2)时, 调整数值
            if (index == 2) index++;
            CGFloat x = index * width;
            CGFloat y = 0;
            subView.frame = CGRectMake(x, y, width, height);
            index++;
        }
    }
    
    self.centerView.center = CGPointMake((self.frame.size.width / 2.f), 0);
    self.titleLabel.center = CGPointMake((self.frame.size.width / 2.f), self.frame.size.height - 10);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.isHidden) {
        return [super hitTest:point withEvent:event];
    }
    
    // 将点击的 位置 转成在中心蓝色视图上的点
    CGPoint middlePoint = [self convertPoint:point toView:self.centerView];
    
    // 中心蓝色视图上的中心位置
    CGPoint center = CGPointMake(self.centerView.frame.size.width * 0.5, self.centerView.frame.size.height * 0.5);
    
    // 使用勾股定理计算出中心点的距离
    CGFloat distance = sqrt(pow(middlePoint.x - center.x, 2) + pow(middlePoint.y - center.y, 2));
    
    // 下面的判断根据个人需求定
    // 1. 如果点击的位置到红色圆的圆心距离 大于 半径, 说明点击的位置不在圆上, 但是有可能在tabBar其他区域上
    // 2. 如果点击的位置在tabBar范围上, 那么middlePoint的y值就是 大于 self.middleView.height - self.height, 反之点击的位置就不在圆内
    // 所以: 综上两点, 当点击的位置即在圆外, 又不在tabBar上时, 直接返回, 此时中间视图上边两个蓝色角也无法响应事件
    BOOL temp1 = distance > self.centerButton.frame.size.width * 0.5;
    CGFloat Y = self.centerView.frame.origin.y - self.frame.size.height;
    BOOL temp2 = Y < middlePoint.y < self.frame.size.height;
    if (temp1 && temp2) {
        return [super hitTest:point withEvent:event];
    }
    return self.centerButton;
}


@end
