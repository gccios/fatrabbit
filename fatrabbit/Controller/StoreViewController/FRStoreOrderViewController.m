//
//  FRStoreOrderViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/17.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreOrderViewController.h"
#import "UserManager.h"
#import "FRStorePayMenuCell.h"
#import "FRChoosePayWayView.h"

@interface FRStoreOrderViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIButton * addressButton;
@property (nonatomic, strong) UILabel * nameLabel;
@property (nonatomic, strong) UILabel * mobileLabel;
@property (nonatomic, strong) UILabel * addressLabel;

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * menuSource;

@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) UILabel * orderNumberLabel;

@property (nonatomic, strong) FRAddressModel * addressModel;

@end

@implementation FRStoreOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.menuSource = [[NSMutableArray alloc] init];
    [self.menuSource addObject:@[[[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_PayWay],
                                 [[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_Points],
                                 [[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_Discount]]];
    [self.menuSource addObject:@[[[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_InvoiceInfo],
                                 [[FRStorePayMenuModel alloc] initWithType:FRStorePayMenuType_Remark]]];
    
    [self createViews];
}

- (void)createViews
{
    self.navigationItem.title = @"确认订单";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.tableView registerClass:[FRStorePayMenuCell class] forCellReuseIdentifier:@"FRStorePayMenuCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    if ([UserManager shareManager].addressList.count > 0) {
        self.addressModel = [UserManager shareManager].addressList.firstObject;
    }
    
    [self createTableHeaderView];
}

- (void)createTableHeaderView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 220 * scale)];
    headerView.backgroundColor = UIColorFromRGB(0xffffff);
    
    self.addressButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [headerView addSubview:self.addressButton];
    [self.addressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(kMainBoundsWidth);
        make.height.mas_equalTo(68 * scale);
    }];
    
    UILabel * addressTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    addressTipLabel.text = @"收货信息";
    [headerView addSubview:addressTipLabel];
    [addressTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.nameLabel.text = @"请选择地址";
    [headerView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(addressTipLabel);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(addressTipLabel.mas_right).offset(15 * scale);
    }];
    
    self.mobileLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [headerView addSubview:self.mobileLabel];
    [self.mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(addressTipLabel);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.nameLabel.mas_right).offset(10 * scale);
    }];
    
    self.addressLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    [headerView addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nameLabel.mas_bottom).offset(0 * scale);
        make.height.mas_equalTo(20 * scale);
        make.left.mas_equalTo(self.nameLabel);
    }];
    
    if (self.addressModel) {
        self.nameLabel.text = self.addressModel.consignee;
        self.mobileLabel.text = self.addressModel.mobile;
        self.addressLabel.text = self.addressModel.address;
    }
    
    UIView * addressLineView = [[UIView alloc] initWithFrame:CGRectZero];
    addressLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:addressLineView];
    [addressLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.addressLabel.mas_bottom).mas_offset(5 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    UILabel * orderTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    orderTipLabel.text = @"订单明细";
    [headerView addSubview:orderTipLabel];
    [orderTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addressLineView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    CGFloat width = (kMainBoundsWidth - 20 * scale) / 5.f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 5 * scale;
    layout.minimumInteritemSpacing = 5 * scale;
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    self.collectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [headerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderTipLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo((width + 10 * scale) * 3);
        make.height.mas_equalTo(width + 10 * scale);
    }];
    
    UIImageView * moreImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [headerView addSubview:moreImageView];
    [moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.collectionView);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    
    self.orderNumberLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    self.orderNumberLabel.text = @"共3件";
    [headerView addSubview:self.orderNumberLabel];
    [self.orderNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(moreImageView);
        make.height.mas_equalTo(20 * scale);
        make.right.mas_equalTo(moreImageView.mas_left).offset(-10 * scale);
    }];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    self.tableView.tableHeaderView = headerView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor greenColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray * data = [self.menuSource objectAtIndex:indexPath.section];
    FRStorePayMenuModel * menuModel = [data objectAtIndex:indexPath.row];
    if (menuModel.type == FRStorePayMenuType_Points || menuModel.type == FRStorePayMenuType_Discount) {
        menuModel.isChoose = !menuModel.isChoose;
        [tableView reloadData];
    }else if (menuModel.type == FRStorePayMenuType_PayWay) {
        FRChoosePayWayView * payway = [[FRChoosePayWayView alloc] initWithModel:menuModel.payWay];
        
        __weak typeof(self) weakSelf = self;
        payway.chooseDidCompletetHandle = ^(FRPayWayModel *model) {
            menuModel.payWay = model;
            [weakSelf.tableView reloadData];
        };
        [payway show];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.menuSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray * data = [self.menuSource objectAtIndex:section];
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRStorePayMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRStorePayMenuCell" forIndexPath:indexPath];
    
    NSArray * data = [self.menuSource objectAtIndex:indexPath.section];
    FRStorePayMenuModel * model = [data objectAtIndex:indexPath.row];
    [cell confiWithModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UITableViewHeaderFooterView * view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return .1f;//把高度设置很小，效果可以看成footer的高度等于0
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;//把高度设置很小，效果可以看成footer的高度等于0
}

- (void)dealloc
{
    
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
