//
//  FROrderDetailViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FROrderDetailViewController.h"
#import "FRCommentLevelView.h"

@interface FROrderDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) UIView * bottomView;
@property (nonatomic, strong) FRCommentLevelView * commentLevelView;

@end

@implementation FROrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createViews];
}

//前去评价
- (void)goToComment
{
    
}

- (void)createViews
{
    self.navigationItem.title = @"订单详情";
    
    self.view.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60 * scale, 0);
    
    [self createTableHeaderView];
    [self createTableFooterView];
    [self createBottomView];
}

- (void)createBottomView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
    }];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat height = 340 * scale;
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)];
    
    UILabel * orderNumberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    orderNumberLabel.text = @"测试编号：111111111111";
    [headerView addSubview:orderNumberLabel];
    [orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * creatTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    creatTimeLabel.text = @"测试时间：2018-08-31 17:29";
    [headerView addSubview:creatTimeLabel];
    [creatTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderNumberLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * payTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    payTimeLabel.text = @"测试时间：2018-08-31 17:30";
    [headerView addSubview:payTimeLabel];
    [payTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(creatTimeLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * sureTimeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    sureTimeLabel.text = @"测试时间：2018-08-31 17:31";
    [headerView addSubview:sureTimeLabel];
    [sureTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payTimeLabel.mas_bottom);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIButton * statusButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangLight(20 * scale) titleColor:UIColorFromRGB(0x333333) title:@"测试订单状态"];
    statusButton.enabled = NO;
    [headerView addSubview:statusButton];
    [statusButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(110 * scale);
        make.height.mas_equalTo(40 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(statusButton.mas_bottom).offset(25 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    UIImageView * companyImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    companyImageView.backgroundColor = [UIColor greenColor];
    [headerView addSubview:companyImageView];
    [companyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.height.mas_equalTo(25 * scale);
    }];
    
    UILabel * companyLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    companyLabel.text = @"测试公司名称测试公司名称";
    [headerView addSubview:companyLabel];
    [companyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(companyImageView);
        make.left.mas_equalTo(companyImageView.mas_right).offset(10 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIView * companyLineView = [[UIView alloc] initWithFrame:CGRectZero];
    companyLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [headerView addSubview:companyLineView];
    [companyLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyImageView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UIImageView * coverImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage new]];
    coverImageView.backgroundColor = [UIColor greenColor];
    [headerView addSubview:coverImageView];
    [coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(companyLineView.mas_bottom).offset(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(120 * scale);
        make.height.mas_equalTo(70 * scale);
    }];
    
    UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangMedium(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    nameLabel.text = @"测试公司名称测试公司名称";
    [headerView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coverImageView).offset(5 * scale);
        make.left.mas_equalTo(coverImageView.mas_right).offset(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 150 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UILabel * numberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(11 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    numberLabel.text = @"测试成交10单";
    [headerView addSubview:numberLabel];
    [numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(coverImageView).offset(-5 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(nameLabel);
    }];
    
    UILabel * totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    totalLabel.text = @"合计：";
    [headerView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(numberLabel);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(numberLabel.mas_right).offset(30 * scale);
    }];
    
    UILabel * totalPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    totalPriceLabel.text = @"测试金额";
    [headerView addSubview:totalPriceLabel];
    [totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(totalLabel);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(totalLabel.mas_right);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (void)createTableFooterView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    CGFloat height = 200 * scale;
    
    NSString * comment = @"暂无评价内容";
    CGSize size = [comment boundingRectWithSize:CGSizeMake(kMainBoundsWidth - 30 * scale, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:kPingFangRegular(12 * scale)} context:nil].size;
    height += size.height;
    
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, height)];
    
    UILabel * commentLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(13 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    commentLabel.text = @"整体评价：";
    [footerView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    UIView * commentLineView = [[UIView alloc] initWithFrame:CGRectZero];
    commentLineView.backgroundColor = UIColorFromRGB(0xCCCCCC);
    [footerView addSubview:commentLineView];
    [commentLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentLabel.mas_bottom).mas_equalTo(20 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
        make.height.mas_equalTo(.5f);
    }];
    
    UILabel * commentDetailLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    commentDetailLabel.numberOfLines = 0;
    commentDetailLabel.text = comment;
    [footerView addSubview:commentDetailLabel];
    [commentDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentLineView.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(15 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 30 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [footerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(commentDetailLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.commentLevelView = [[FRCommentLevelView alloc] initWithCommentNormal];
    [self.commentLevelView showWithServiceLevel:2 companyLevel:4 businessLevel:3];
    [footerView addSubview:self.commentLevelView];
    [self.commentLevelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView.mas_bottom);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(125 * scale);
    }];
    
    self.tableView.tableFooterView = footerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return .1f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
