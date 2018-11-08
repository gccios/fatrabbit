//
//  FRChoosePayWayView.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/19.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRChoosePayWayView.h"
#import "FRChoosePayWayCell.h"
#import "FRCreateViewTool.h"
#import <Masonry.h>

@interface FRChoosePayWayView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * dataSource;

@property (nonatomic, strong) FRPayWayModel * model;
@property (nonatomic, assign) FRPayWayType payType;

@property (nonatomic, assign) BOOL isServiceChoose;

@end

@implementation FRChoosePayWayView

- (instancetype)initWithModel:(FRPayWayModel *)model
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.payType = model.type;
        [self createChooseView];
    }
    return self;
}

- (instancetype)initServiceChooseWithModel:(FRPayWayModel *)model
{
    if (self = [super initWithFrame:[UIScreen mainScreen].bounds]) {
        self.payType = model.type;
        self.isServiceChoose = YES;
        [self createChooseView];
    }
    return self;
}

- (void)show
{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.mas_equalTo(0);
    }];
    
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(0, kMainBoundsHeight / 3.f, kMainBoundsWidth, kMainBoundsHeight / 3.f * 2);
    } completion:nil];
}

- (void)close
{
    [UIView animateWithDuration:.2f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.contentView.frame = CGRectMake(0, kMainBoundsHeight, kMainBoundsWidth, kMainBoundsHeight / 3.f * 2);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)handleButtonDidClecked
{
    self.chooseDidCompletetHandle(self.model);
    [self close];
}

- (void)createChooseView
{
    self.dataSource = @[[[FRPayWayModel alloc] initWithType:FRPayWayType_Wechat],
                        [[FRPayWayModel alloc] initWithType:FRPayWayType_Alipay],
                        [[FRPayWayModel alloc] initWithType:FRPayWayType_Balance],
                        [[FRPayWayModel alloc] initWithType:FRPayWayType_UnderLine],
                        [[FRPayWayModel alloc] initWithType:FRPayWayType_FenQi]];
    
    if (self.isServiceChoose) {
        self.dataSource = @[[[FRPayWayModel alloc] initWithType:FRPayWayType_Wechat],
                            [[FRPayWayModel alloc] initWithType:FRPayWayType_Alipay]];
    }
    
    for (FRPayWayModel * model in self.dataSource) {
        if (model.type == self.payType) {
            self.model = model;
            break;
        }
    }
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.5f];
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * spaceView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:spaceView];
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.height.mas_equalTo(kMainBoundsHeight / 3.f);
    }];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [spaceView addGestureRecognizer:tap];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, kMainBoundsHeight, kMainBoundsWidth, kMainBoundsHeight / 3.f * 2)];
    self.contentView.backgroundColor = UIColorFromRGB(0xffffff);
    [self addSubview:self.contentView];
    
    UILabel * titleLabel = [FRCreateViewTool createLabelWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 60 * scale) font:kPingFangRegular(15 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentCenter];
    titleLabel.text = @"选择支付方式";
    [self.contentView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(60 * scale);
    }];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xffffff);
    self.tableView.rowHeight = 50 * scale;
    [self.tableView registerClass:[FRChoosePayWayCell class] forCellReuseIdentifier:@"FRChoosePayWayCell"];
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom);
        make.left.bottom.right.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 50 * scale, 0);
    
    UIButton * handleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(13 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"确定"];
    [handleButton setBackgroundColor:KPriceColor];
    [self.contentView addSubview:handleButton];
    [handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [handleButton addTarget:self action:@selector(handleButtonDidClecked) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRChoosePayWayCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRChoosePayWayCell" forIndexPath:indexPath];
    
    FRPayWayModel * model = [self.dataSource objectAtIndex:indexPath.row];
    
    BOOL isChoose = NO;
    if (self.model == model) {
        isChoose = YES;
    }
    [cell configWithModel:model withChoose:isChoose];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRPayWayModel * model = [self.dataSource objectAtIndex:indexPath.row];
    if (model.type == FRPayWayType_FenQi) {
        return;
    }
    self.model = model;
    [self.tableView reloadData];
}

@end
