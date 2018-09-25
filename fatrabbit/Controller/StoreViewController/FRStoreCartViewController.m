//
//  FRStoreCartViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/8/31.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRStoreCartViewController.h"
#import "FRStoreCartTableViewCell.h"
#import "UserManager.h"
#import "FRStoreCartRequest.h"
#import "FRStoreOrderViewController.h"
#import "MBProgressHUD+FRHUD.h"

@interface FRStoreCartViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, weak) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * bottomPayView;
@property (nonatomic, strong) UIButton * allSelectButton;
@property (nonatomic, strong) UIButton * payButton;
@property (nonatomic, strong) UILabel * totalPriceLabel;
@property (nonatomic, strong) UILabel * salePriceLabel;
@property (nonatomic, strong) UILabel * saleRemarkLabel;

@property (nonatomic, assign) BOOL isAllChoose;
@property (nonatomic, assign) CGFloat totalPrice;

@end

@implementation FRStoreCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物车";
    [self requestStoreCartList];
    
    [self createViews];
}

- (void)requestStoreCartList
{
    self.dataSource = [UserManager shareManager].storeCart;
}

- (void)allSelectButtonDidClicked
{
    self.isAllChoose = !self.isAllChoose;
    if (self.isAllChoose) {
        [self.dataSource makeObjectsPerformSelector:@selector(changeToSelect)];
        [self.tableView reloadData];
        [self.allSelectButton setTitle:@"取消全选" forState:UIControlStateNormal];
    }else{
        [self.dataSource makeObjectsPerformSelector:@selector(changeToNoSelect)];
        [self.tableView reloadData];
        [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
    }
}

- (void)payButtonDidClicked
{
    NSMutableArray * paySource = [[NSMutableArray alloc] init];
    for (FRStoreCartModel * model in self.dataSource) {
        if (model.isSelected == YES) {
            [paySource addObject:model];
        }
    }
    
    if (paySource.count == 0) {
        [MBProgressHUD showTextHUDWithText:@"请先选择要结算的商品"];
    }else{
        FRStoreOrderViewController * order = [[FRStoreOrderViewController alloc] initWithSource:paySource];
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)createViews
{
    
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
    self.tableView.tableFooterView = [UIView new];
    
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
    [self.allSelectButton addTarget:self action:@selector(allSelectButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.payButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(17 * scale) titleColor:UIColorFromRGB(0xFFFFFF) title:@"结算"];
    self.payButton.backgroundColor = KPriceColor;
    [self.bottomPayView addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.mas_equalTo(0);
        make.width.mas_equalTo(80 * scale);
    }];
    [self.payButton addTarget:self action:@selector(payButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel * totalLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    totalLabel.text = @"合计：";
    [self.bottomPayView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.centerX.mas_equalTo(-40 * scale);
        make.height.mas_equalTo(15 * scale);
    }];
    
    self.totalPriceLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:KThemeColor alignment:NSTextAlignmentLeft];
    self.totalPriceLabel.text = @"￥0";
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
    self.salePriceLabel.text = @"￥0";
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
    
    FRStoreCartModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithGoodsModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.addCartHandle = ^(FRStoreCartModel *cartModel) {
        [weakSelf addWithModel:cartModel];
    };
    
    cell.deleteCartHandle = ^(FRStoreCartModel *cartModel) {
        [weakSelf deleteWithModel:cartModel];
    };
    
    cell.chooseCartHandle = ^(FRStoreCartModel *cartModel) {
        [weakSelf chooseWithModel:cartModel];
    };
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        FRStoreCartModel * model = [self.dataSource objectAtIndex:indexPath.row];
        [self.dataSource removeObject:model];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self deleteWithModel:model];
    }
}

- (void)addWithModel:(FRStoreCartModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initAddWithStoreID:model.sid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
    if (model.isSelected) {
        self.totalPrice += model.price;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.totalPrice];
    }
}

- (void)deleteWithModel:(FRStoreCartModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initDeleteWithStoreID:model.sid];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
    if (model.isSelected) {
        self.totalPrice -= model.price;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.totalPrice];
    }
}

- (void)chooseWithModel:(FRStoreCartModel *)model
{
    if (model.isSelected) {
        self.totalPrice += model.amount;
    }else{
        self.totalPrice -= model.amount;
    }
    self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.totalPrice];
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
