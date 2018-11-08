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
#import "FROrderRequest.h"
#import "FRMyStoreOrderModel.h"
#import "FROrderDetailViewController.h"

@interface FRStoreCartViewController () <UITableViewDelegate, UITableViewDataSource, FRStoreOrderViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) NSMutableArray * dataSource;

@property (nonatomic, strong) UIView * bottomPayView;
@property (nonatomic, strong) UIButton * selectImageButton;
@property (nonatomic, strong) UIButton * allSelectButton;
@property (nonatomic, strong) UIButton * payButton;
@property (nonatomic, strong) UILabel * totalPriceLabel;
@property (nonatomic, strong) UILabel * salePriceLabel;
@property (nonatomic, strong) UILabel * saleRemarkLabel;

@property (nonatomic, assign) BOOL isAllChoose;
@property (nonatomic, assign) CGFloat totalPrice;
@property (nonatomic, assign) CGFloat payTotalPrice;
@property (nonatomic, assign) CGFloat totalPoints;
@property (nonatomic, assign) CGFloat discountPrice;

@end

@implementation FRStoreCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"购物车";
    
    [self createViews];
    [self requestStoreCartList];
}

- (void)requestStoreCartList
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initWithStoreList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            if (KIsDictionary(data)) {
                NSArray * list = [data objectForKey:@"list"];
                if (KIsArray(list)) {
                    self.dataSource = [FRStoreCartModel mj_objectArrayWithKeyValuesArray:list];
                    [self.tableView reloadData];
                    
                    [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
                    [self.selectImageButton setImage:[UIImage imageNamed:@"chooseno"] forState:UIControlStateNormal];
                    self.totalPoints = 0;
                    self.totalPrice = 0;
                    self.payTotalPrice = 0;
                    self.discountPrice = 0;
                    [self updatePriceInfo];
                }
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        
    }];
}

- (void)allSelectButtonDidClicked
{
    self.isAllChoose = !self.isAllChoose;
    if (self.isAllChoose) {
        [self.dataSource makeObjectsPerformSelector:@selector(changeToSelect)];
        [self.tableView reloadData];
        [self.allSelectButton setTitle:@"取消全选" forState:UIControlStateNormal];
        [self.selectImageButton setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateNormal];
        [self updateStoreCart];
    }else{
        [self.dataSource makeObjectsPerformSelector:@selector(changeToNoSelect)];
        [self.tableView reloadData];
        [self.allSelectButton setTitle:@"全选" forState:UIControlStateNormal];
        [self.selectImageButton setImage:[UIImage imageNamed:@"chooseno"] forState:UIControlStateNormal];
        self.totalPoints = 0;
        self.totalPrice = 0;
        self.payTotalPrice = 0;
        self.discountPrice = 0;
        [self updatePriceInfo];
    }
}

- (void)payButtonDidClicked
{
    NSMutableArray * paySource = [[NSMutableArray alloc] init];
    BOOL hasPoint = NO;
    BOOL hasPrice = NO;
    for (FRStoreCartModel * model in self.dataSource) {
        if (model.isSelected == YES) {
            [paySource addObject:model];
            if (model.is_points) {
                hasPoint = YES;
            }else{
                hasPrice = YES;
            }
        }
    }
    
    if (hasPoint == YES && hasPrice == YES) {
        [MBProgressHUD showTextHUDWithText:@"积分商品需要单独结算，请重试"];
        return;
    }
    
    if (paySource.count == 0) {
        [MBProgressHUD showTextHUDWithText:@"请先选择要结算的商品"];
    }else{
        FRStoreOrderViewController * order = [[FRStoreOrderViewController alloc] initWithSource:paySource];
        order.totalPoints = self.totalPoints;
        order.totalPrice = self.totalPrice;
        order.payTotalPrice = self.payTotalPrice;
        order.discountPrice = self.discountPrice;
        order.delegate = self;
        [self.navigationController pushViewController:order animated:YES];
    }
}

- (void)storeOrderHandleWithOrderID:(NSInteger)orderID
{
    [self requestStoreCartList];
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
    
    self.selectImageButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(12) titleColor:UIColorFromRGB(0xffffff) title:@""];
    [self.selectImageButton setImage:[UIImage imageNamed:@"chooseno"] forState:UIControlStateNormal];
    [self.bottomPayView addSubview:self.selectImageButton];
    [self.selectImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo(20);
        make.width.height.mas_equalTo(20 * scale);
    }];
    [self.selectImageButton addTarget:self action:@selector(allSelectButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.allSelectButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15) titleColor:UIColorFromRGB(0x333333) title:@"全选"];
    [self.bottomPayView addSubview:self.allSelectButton];
    [self.allSelectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(40 * scale);
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
    totalLabel.text = @"合计:";
    [self.bottomPayView addSubview:totalLabel];
    [totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(110 * scale);
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
    saleLabel.text = @"优惠:";
    [self.bottomPayView addSubview:saleLabel];
    [saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(totalLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(110 * scale);
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
    
    self.saleRemarkLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentLeft];
    if (!isEmptyString([UserManager shareManager].vip_name)) {
        self.saleRemarkLabel.text = [NSString stringWithFormat:@"(%@ %@)", [UserManager shareManager].vip_name, [UserManager shareManager].vip_discount_tip];
    }
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
        
        if (cartModel.num == 0) {
            if ([weakSelf.dataSource containsObject:cartModel]) {
                [weakSelf.dataSource removeObject:cartModel];
                [weakSelf.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                [weakSelf deleteWithModel:cartModel];
            }
        }else{
            [weakSelf deleteWithModel:cartModel];
        }
        
    };
    
    cell.chooseCartHandle = ^(FRStoreCartModel *cartModel) {
        [weakSelf chooseWithModel:cartModel];
    };
    
    cell.numberCartHandle = ^(FRStoreCartModel *cartModel) {
        [weakSelf changeNumberWithModel:cartModel];
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
        
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"移除商品" message:@"确认从购物车中移除改商品吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        UIAlertAction * action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            FRStoreCartModel * model = [self.dataSource objectAtIndex:indexPath.row];
            [self.dataSource removeObject:model];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initRemovetWithStoreIDs:@[@(model.cid)]];
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                [[UserManager shareManager] requestStoreCartList];
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
            }];
            
        }];
        
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)changeNumberWithModel:(FRStoreCartModel *)model
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入您要购买的商品数量" preferredStyle:UIAlertControllerStyleAlert];
    
    //添加一个取消按钮
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //以下方法就可以实现在提示框中输入文本；
    
    //在AlertView中添加一个输入框
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    
    //添加一个确定按钮 并获取AlertView中的第一个输入框 将其文本赋值给BUTTON的title
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *textField = alertController.textFields.firstObject;
        NSInteger number = [textField.text integerValue];
        if (number != 0) {
            
            FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initAddWithStoreID:model.sid];
            
            if (model.isSelected) {
                NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isSelected == YES"];
                NSArray * chooseSource = [self.dataSource filteredArrayUsingPredicate:predicate];
                
                NSMutableArray * cardList = [[NSMutableArray alloc] init];
                for (FRStoreCartModel * model in chooseSource) {
                    [cardList addObject:@(model.cid)];
                }
                [request configWithCardIDList:cardList];
            }
            
            [request configWithNum:number];
            
            [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                model.num = number;
                [self.tableView reloadData];
                
                NSDictionary * data = [response objectForKey:@"data"];
                if (KIsDictionary(data)) {
                    CGFloat points = [[data objectForKey:@"mypoints"] floatValue];
                    [UserManager shareManager].points = points;
                    
                    if (model.isSelected) {
                        self.totalPoints = [[data objectForKey:@"points"] floatValue];
                        self.totalPrice = [[data objectForKey:@"totalamount"] floatValue];
                        self.payTotalPrice = [[data objectForKey:@"payamount"] floatValue];
                        self.discountPrice = [[data objectForKey:@"discounts"] floatValue];
                        
                        [self updateStoreCart];
                    }
                }
                
            } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
                
                NSString * msg = [response objectForKey:@"msg"];
                if (!isEmptyString(msg)) {
                    [MBProgressHUD showTextHUDWithText:msg];
                }
                
            } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
                
                [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
                
            }];
            
        }
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addWithModel:(FRStoreCartModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initAddWithStoreID:model.sid];
    
    if (model.isSelected) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isSelected == YES"];
        NSArray * chooseSource = [self.dataSource filteredArrayUsingPredicate:predicate];
        
        NSMutableArray * cardList = [[NSMutableArray alloc] init];
        for (FRStoreCartModel * model in chooseSource) {
            [cardList addObject:@(model.cid)];
        }
        [request configWithCardIDList:cardList];
    }
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        model.num++;
        [self.tableView reloadData];
        
        NSDictionary * data = [response objectForKey:@"data"];
        if (KIsDictionary(data)) {
            CGFloat points = [[data objectForKey:@"mypoints"] floatValue];
            [UserManager shareManager].points = points;
            
            if (model.isSelected) {
                self.totalPoints = [[data objectForKey:@"points"] floatValue];
                self.totalPrice = [[data objectForKey:@"totalamount"] floatValue];
                self.payTotalPrice = [[data objectForKey:@"payamount"] floatValue];
                self.discountPrice = [[data objectForKey:@"discounts"] floatValue];
                
                [self updateStoreCart];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        
        
    }];
}

- (void)deleteWithModel:(FRStoreCartModel *)model
{
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initDeleteWithStoreID:model.sid];
    if (model.isSelected) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isSelected == YES"];
        NSArray * chooseSource = [self.dataSource filteredArrayUsingPredicate:predicate];
        
        NSMutableArray * cardList = [[NSMutableArray alloc] init];
        for (FRStoreCartModel * model in chooseSource) {
            [cardList addObject:@(model.cid)];
        }
        [request configWithCardIDList:cardList];
    }
    
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        model.num--;
        [self.tableView reloadData];
        
        NSDictionary * data = [response objectForKey:@"data"];
        if (KIsDictionary(data)) {
            CGFloat points = [[data objectForKey:@"mypoints"] floatValue];
            [UserManager shareManager].points = points;
            
            if (model.isSelected) {
                self.totalPoints = [[data objectForKey:@"points"] floatValue];
                self.totalPrice = [[data objectForKey:@"totalamount"] floatValue];
                self.payTotalPrice = [[data objectForKey:@"payamount"] floatValue];
                self.discountPrice = [[data objectForKey:@"discounts"] floatValue];
                
                [self updateStoreCart];
            }
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        
        
    }];
}

- (void)chooseWithModel:(FRStoreCartModel *)model
{
    [self updateStoreCart];
}

- (void)updateStoreCart
{
    [FRStoreCartRequest cancelRequest];
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isSelected == YES"];
    NSArray * chooseSource = [self.dataSource filteredArrayUsingPredicate:predicate];
    
    if (chooseSource.count == 0) {
        self.totalPoints = 0;
        self.totalPrice = 0;
        self.payTotalPrice = 0;
        self.discountPrice = 0;
        [self updatePriceInfo];
        return;
    }
    
    NSMutableArray * cardList = [[NSMutableArray alloc] init];
    for (FRStoreCartModel * model in chooseSource) {
        [cardList addObject:@(model.cid)];
    }
    
    FRStoreCartRequest * request = [[FRStoreCartRequest alloc] initWithStoreList];
    [request configWithCardIDList:cardList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        
        NSDictionary * data = [response objectForKey:@"data"];
        if (KIsDictionary(data)) {
            CGFloat points = [[data objectForKey:@"mypoints"] floatValue];
            [UserManager shareManager].points = points;
            
            self.totalPoints = [[data objectForKey:@"points"] floatValue];
            self.totalPrice = [[data objectForKey:@"totalamount"] floatValue];
            self.payTotalPrice = [[data objectForKey:@"payamount"] floatValue];
            self.discountPrice = [[data objectForKey:@"discounts"] floatValue];
        }
        
        [self updatePriceInfo];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
    }];
}

- (void)updatePriceInfo
{
    if (self.totalPrice > 0) {
        if (self.totalPoints > 0) {
            self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf+%.2lf 积分", self.payTotalPrice, self.totalPoints];
        }else{
            self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.payTotalPrice];
        }
    }else if (self.totalPoints > 0){
        self.totalPriceLabel.text = [NSString stringWithFormat:@"%.2lf 积分", self.totalPoints];
    }else{
        self.totalPriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.payTotalPrice];
    }
    self.salePriceLabel.text = [NSString stringWithFormat:@"￥%.2lf", self.discountPrice];
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
