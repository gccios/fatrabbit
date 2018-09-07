//
//  FRStoreCartViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartViewController.h"
#import "FRStoreCartTableViewCell.h"

@interface FRStoreCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * bottomPayView;
@property (nonatomic, strong) UIButton * allSelectButton;
@property (nonatomic, strong) UIButton * payButton;
@property (nonatomic, strong) UILabel * totalPriceLabel;
@property (nonatomic, strong) UILabel * salePriceLabel;
@property (nonatomic, strong) UILabel * saleRemarkLabel;

@end

@implementation FRStoreCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (NSInteger i = 0; i < 20; i++) {
        FRStoreModel * model = [[FRStoreModel alloc] init];
        model.number = 1;
        model.price = arc4random()%100 + 1;
        [self.dataSource addObject:model];
    }
    
    [self createViews];
}

- (void)createViews
{
    self.navigationItem.title = @"购物车";
    
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorFromRGB(0xFFFFFF);
    self.tableView.rowHeight = 110 * scale;
    [self.tableView registerClass:[FRStoreCartTableViewCell class] forCellReuseIdentifier:@"FRStoreCartTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60 * scale, 0);
    
    [self createBottomPayView];
}

- (void)createBottomPayView
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.bottomPayView = [[UIView alloc] initWithFrame:CGRectZero];
    self.bottomPayView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.view addSubview:self.bottomPayView];
    [self.bottomPayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(55 * scale);
    }];
    
    self.allSelectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0x333333) title:@"全选"];
    [self.bottomPayView addSubview:self.allSelectButton];
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(20 * scale);
        make.bottom.mas_equalTo(-10 * scale);
    }];
    
    self.payButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(17 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"结算"];
    self.payButton.backgroundColor = KPriceColor;
    [self.bottomPayView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80 * scale);
    }];
    
    UILabel * totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    totalLabel.text = @"合计：";
    [self.bottomPayView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.centerX.mas_equalTo(-40 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.totalPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.totalPriceLabel.text = @"￥2200";
    [self.bottomPayView addSubview:self.totalPriceLabel];
    [self.totalPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(totalLabel);
        make.height.mas_equalTo(totalLabel);
        make.left.mas_equalTo(totalLabel.mas_right);
    }];
    
    UILabel * saleLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    saleLabel.text = @"优惠：";
    [self.bottomPayView addSubview:saleLabel];
    [saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalLabel.mas_bottom).offset(5 * scale);
        make.centerX.mas_equalTo(-40 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.salePriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.salePriceLabel.text = @"￥50";
    [self.bottomPayView addSubview:self.salePriceLabel];
    [self.salePriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(saleLabel);
        make.height.mas_equalTo(saleLabel);
        make.left.mas_equalTo(saleLabel.mas_right);
    }];
    
    self.saleRemarkLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x666666) alignment:NSTextAlignmentLeft];
    self.saleRemarkLabel.text = @"(VIP真的叼)";
    [self.bottomPayView addSubview:self.saleRemarkLabel];
    [self.saleRemarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.salePriceLabel);
        make.height.mas_equalTo(self.salePriceLabel);
        make.left.mas_equalTo(self.salePriceLabel.mas_right).offset(5 * scale);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRStoreCartTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRStoreCartTableViewCell" forIndexPath:indexPath];
    
    FRStoreModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithGoodsModel:model];
    
    return cell;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
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
