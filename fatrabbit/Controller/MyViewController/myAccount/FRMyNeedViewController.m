//
//  FRMyNeedViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/29.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRMyNeedViewController.h"
#import "FRNeedListRequest.h"
#import "FRNeedDetailRequest.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRMyNeedTableViewCell.h"
#import <UIImageView+WebCache.h>
#import "FRNeedDetailViewController.h"
#import "FRPublishNeedController.h"
#import <MJRefresh.h>

@interface FRMyNeedViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;

@end

@implementation FRMyNeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"我的需求";
    
    [self requestMyNeed];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(requestMyNeed) name:FRNeedDidPublishNotification object:nil];
}

- (void)requestMyNeed
{
    FRNeedListRequest * request = [[FRNeedListRequest alloc] initWithMyNeedList];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSArray * data = [response objectForKey:@"data"];
            if (KIsArray(data)) {
                self.dataSource = [FRNeedModel mj_objectArrayWithKeyValuesArray:data];
                [self createViews];
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

- (void)deleteWithModel:(FRNeedModel *)model
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确认删除该需求" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        FRNeedListRequest * request = [[FRNeedListRequest alloc] initWithDeleteNeedID:model.cid];
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

- (void)editWithModel:(FRNeedModel *)model
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在加载" inView:self.view];
    if (model.img.count > 0) {
        [self requestEditModelImageSource:model];
    }else{
        FRNeedDetailRequest * request = [[FRNeedDetailRequest alloc] initWithNeedID:model.cid];
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

- (void)requestEditModelImageSource:(FRNeedModel *)model
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

- (void)editWithModel:(FRNeedModel *)model imageSource:(NSArray *)imageSource
{
    FRCateModel * cate = [[FRCateModel alloc] init];
    cate.cid = model.second_cate_id;
    cate.name = model.second_cate_name;
    
    FRPublishNeedController * publish = [[FRPublishNeedController alloc] initEditWithNeedModel:model imageSource:imageSource cateModel:cate];
    [self.navigationController pushViewController:publish animated:YES];
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FRMyNeedTableViewCell class] forCellReuseIdentifier:@"FRMyNeedTableViewCell"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60 * scale, 0);
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestMyNeed)];
}

#pragma mark - UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRMyNeedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"FRMyNeedTableViewCell" forIndexPath:indexPath];
    
    FRNeedModel * model = [self.dataSource objectAtIndex:indexPath.row];
    [cell configWithModel:model];
    
    __weak typeof(self) weakSelf = self;
    cell.deleteHandle = ^(FRNeedModel *needModel) {
        [weakSelf deleteWithModel:needModel];
    };
    
    cell.editHandle = ^(FRNeedModel *needModel) {
        [weakSelf editWithModel:needModel];
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140 * kMainBoundsWidth / 375.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRNeedModel * model = [self.dataSource objectAtIndex:indexPath.row];
    FRNeedDetailViewController * detail = [[FRNeedDetailViewController alloc] initWithNeedModel:model];
    [self.navigationController pushViewController:detail animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:FRNeedDidPublishNotification object:nil];
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
