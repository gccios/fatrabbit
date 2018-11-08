//
//  FRMyServiceViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/12.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyServiceViewController.h"
#import "FRMyServiceTableViewCell.h"
#import "FRCateListViewController.h"
#import "FRPublishServiceViewController.h"
#import "FRServiceRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import <MJRefresh.h>
#import <UIImageView+WebCache.h>
#import "FRServiceDetailViewController.h"

@interface FRMyServiceViewController () <UITableViewDelegate, UITableViewDataSource, FRCateListViewControllerDelegate, FRPublishServiceViewControllerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self requestMyService];
    [self createViews];
}

- (void)FRPublishServiceDidUpdate
{
    [self requestMyService];
}

- (void)requestMyService
{
    FRServiceRequest * request = [[FRServiceRequest alloc] initWithMySerivice];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                self.dataSource = [FRMySeriviceModel mj_objectArrayWithKeyValuesArray:data];
                [self.tableView reloadData];
            }
        }
        [self.tableView.mj_header endRefreshing];
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        NSString * msg = [response objectForKey:@"msg"];
        if (!isEmptyString(msg)) {
            [MBProgressHUD showTextHUDWithText:msg];
        }
        [self.tableView.mj_header endRefreshing];
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)deleteWithModel:(FRMySeriviceModel *)model
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除该服务" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FRServiceRequest * request = [[FRServiceRequest alloc] initDeleteWithID:model.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            [self.dataSource removeObject:model];
            [self.tableView reloadData];
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        }];
        
    }];
    
    [alert addAction:cancleAction];
    [alert addAction:sureAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)editWithModel:(FRMySeriviceModel *)model
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    if (model.img.count > 0) {
        [self requestEditModelImageSource:model];
    }else{
        FRServiceRequest * request = [[FRServiceRequest alloc] initDetailWithSeriviceID:model.cid];
        [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            
            if (KIsDictionary(response)) {
                NSDictionary * data = [response objectForKey:@"data"];
                [model mj_setKeyValues:data];
                
                [self requestEditModelImageSource:model];
            }
            
        } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
            [hud hideAnimated:YES];
            NSString * msg = [response objectForKey:@"msg"];
            if (!isEmptyString(msg)) {
                [MBProgressHUD showTextHUDWithText:msg];
            }
        } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
            [hud hideAnimated:YES];
            [MBProgressHUD showTextHUDWithText:@"网络失去连接"];
        }];
    }
}

- (void)requestEditModelImageSource:(FRMySeriviceModel *)model
{
    NSMutableArray * imageSource = [[NSMutableArray alloc] init];
    if (model.img.count > 0) {
        
        __block NSInteger count = 0;
        for (NSInteger i = 0; i < model.img.count; i++) {
            UIImage * tempImage = [UIImage new];
            [imageSource addObject:tempImage];
            
            NSString * urlStr = [model.img objectAtIndex:i];
            UIImage * resultImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
            if (!resultImage) {
                [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                    
                } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                    [imageSource replaceObjectAtIndex:i withObject:image];
                    count++;
                    if (count == model.img.count) {
                        [MBProgressHUD hideHUDForView:self.view animated:YES];
                        [self editWithModel:model imageSource:imageSource];
                    }
                }];
            }else{
                [imageSource replaceObjectAtIndex:i withObject:resultImage];
                count++;
                if (count == model.img.count) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self editWithModel:model imageSource:imageSource];
                }
            }
        }
        
    }
}

- (void)editWithModel:(FRMySeriviceModel *)model imageSource:(NSArray *)imageSource
{
    FRCateModel * cate = [[FRCateModel alloc] init];
    cate.cid = model.second_cate_id;
    cate.name = model.second_cate_name;
    
    FRPublishServiceViewController * publish = [[FRPublishServiceViewController alloc] initEditWithServiceModel:model imageSource:imageSource cateModel:cate];
    publish.delegate = self;
    [self.navigationController pushViewController:publish animated:YES];
}

- (void)publishButtonDidClicked
{
    FRCateListViewController * vc = [[FRCateListViewController alloc] initWithType:FRCateListType_Publish];
    vc.isPublishService = YES;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - FRCateListViewControllerDelegate
- (void)FRcateListViewCongtrollerDidChoose:(FRCateModel *)model type:(FRCateListType)type
{
    FRPublishServiceViewController * need = [[FRPublishServiceViewController alloc] initWithFRCateModel:model];
    need.delegate = self;
    [self.navigationController pushViewController:need animated:YES];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.navigationItem.title = @"我的服务";
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMyServiceTableViewCell class] forCellReuseIdentifier:@"FRMyServiceTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60 * scale, 0);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMyService)];
    
    UIButton * pulishButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"发布新服务"];
    pulishButton.backgroundColor = KPriceColor;
    [self.view addSubview:pulishButton];
    [pulishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40 * scale);
    }];
    [pulishButton addTarget:self action:@selector(publishButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyServiceTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyServiceTableViewCell" forIndexPath:indexPath];
    
    FRMySeriviceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteHandle = ^(FRMySeriviceModel *seriviceModel) {
        [weakSelf deleteWithModel:seriviceModel];
    };
    
    cell.editHandle = ^(FRMySeriviceModel *seriviceModel) {
        [weakSelf editWithModel:seriviceModel];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMySeriviceModel * model = [self.dataSource objectAtIndex:indexPath.row];
    FRServiceDetailViewController * detail = [[FRServiceDetailViewController alloc] initWithSeriviceModel:model];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
