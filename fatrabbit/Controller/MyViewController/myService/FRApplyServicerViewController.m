//
//  FRApplyServicerViewController.m
//  fatrabbit
//
//  Created by 郭春城 on 2018/9/26.
//  Copyright © 2018年 郭春城. All rights reserved.
//

#import "FRApplyServicerViewController.h"
#import "RDTextView.h"
#import "MBProgressHUD+FRHUD.h"
#import "FRImageCollectionViewCell.h"
#import <TZImagePickerController.h>
#import "LookImageViewController.h"
#import "FRProvideRequest.h"
#import "FRProvideModel.h"
#import "UserManager.h"
#import "FRAllCateListViewController.h"
#import "FRCityViewController.h"
#import <UIImageView+WebCache.h>
#import "FRUploadManager.h"

@interface FRApplyServicerViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, TZImagePickerControllerDelegate, FRAllCateListViewControllerDelegate, FRCityViewControllerDelegate>

@property (nonatomic, strong) UIView * contentView;

@property (nonatomic, strong) UILabel * serviceTypeLabel;
@property (nonatomic, strong) UILabel * serviceRoundLabel;
@property (nonatomic, strong) UIImageView * cardImageView;

@property (nonatomic, strong) RDTextView * textView;

@property (nonatomic, strong) UICollectionView * imageCollectionView;
@property (nonatomic, strong) NSMutableArray * imageSource;
@property (nonatomic, assign) NSInteger maxCount;

@property (nonatomic, strong) UITextField * nameField;
@property (nonatomic, strong) UITextField * mobileField;

@property (nonatomic, strong) FRProvideModel * provideModel;
@property (nonatomic, strong) FRCateModel * chooseCateModel;
@property (nonatomic, strong) FRCityModel * chooseCityModel;

@property (nonatomic, strong) UIButton * handleButton;

@end

@implementation FRApplyServicerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"申请认证";
    self.maxCount = 3;
    
    FRProvideRequest * request = [[FRProvideRequest alloc] initWithProvideDetail];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        if (KIsDictionary(response)) {
            NSDictionary * data = [response objectForKey:@"data"];
            self.provideModel = [FRProvideModel mj_objectWithKeyValues:data];
            
            self.chooseCateModel = [[FRCateModel alloc] init];
            self.chooseCateModel.cid = self.provideModel.cate_id;
            self.chooseCateModel.name = self.provideModel.cate_name;
            
            self.chooseCityModel = [[FRCityModel alloc] init];
            self.chooseCityModel.cid = self.provideModel.region_id;
            self.chooseCityModel.name = self.provideModel.region_name;
            
            [self createViews];
        }
        
    } businessFailure:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [self createViews];
        
    } networkFailure:^(BGNetworkRequest * _Nonnull request, NSError * _Nullable error) {
        
        [self createViews];
        
    }];
}

- (void)handleButtonDidClicked
{
    if (nil == self.chooseCateModel) {
        [MBProgressHUD showTextHUDWithText:@"请选择服务类型"];
        return;
    }
    if (nil == self.chooseCityModel) {
        [MBProgressHUD showTextHUDWithText:@"请选择服务范围"];
        return;
    }
    NSString * name = self.nameField.text;
    if (isEmptyString(name)) {
        [MBProgressHUD showTextHUDWithText:@"请填写公司名称"];
        return;
    }
    NSString * remark = self.textView.text;
    if (isEmptyString(remark)) {
        [MBProgressHUD showTextHUDWithText:@"请填写公司资质说明"];
        return;
    }
    if (nil == self.cardImageView.image) {
        [MBProgressHUD showTextHUDWithText:@"请上传营业执照"];
        return;
    }
    NSString * mobile = self.mobileField.text;
    if (isEmptyString(mobile)) {
        [MBProgressHUD showTextHUDWithText:@"请填写联系方式"];
        return;
    }
    
    MBProgressHUD * cardHud = [MBProgressHUD showLoadingHUDWithText:@"正在上传营业执照" inView:self.view];
    __block NSString * cardImageURL = @"";
    NSMutableArray * imagePaths = [[NSMutableArray alloc] init];
    [[FRUploadManager shareManager] uploadImageArray:@[self.cardImageView.image] progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        
    } success:^(NSString *path, NSInteger index) {
        
        cardImageURL = path;
        
        [cardHud hideAnimated:NO];
        if (self.imageSource.count > 0) {
            MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在上传其它证件" inView:self.view];
            
            [[FRUploadManager shareManager] uploadImageArray:self.imageSource progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
                
            } success:^(NSString *path, NSInteger index) {
                
                [imagePaths addObject:path];
                if (imagePaths.count == self.imageSource.count) {
                    [hud hideAnimated:NO];
                    [self applyWithCateID:self.chooseCateModel.cid cityID:self.chooseCityModel.cid mobile:mobile imgs:imagePaths business_license:cardImageURL remark:remark name:name];
                }
                
            } failure:^(NSError *error, NSInteger index) {
                [hud hideAnimated:YES];
                [MBProgressHUD showTextHUDWithText:@"其它证件上传失败"];
            }];
        }else{
            [self applyWithCateID:self.chooseCateModel.cid cityID:self.chooseCityModel.cid mobile:mobile imgs:imagePaths business_license:cardImageURL remark:remark name:name];
        }
        
    } failure:^(NSError *error, NSInteger index) {
        
        [cardHud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"营业执照上传失败"];
        
    }];
}

- (void)applyWithCateID:(NSInteger)cateID cityID:(NSInteger)cityID mobile:(NSString *)mobile imgs:(NSArray *)imgs business_license:(NSString *)business_license remark:(NSString *)remark name:(NSString *)name
{
    MBProgressHUD * hud = [MBProgressHUD showLoadingHUDWithText:@"正在上传审核信息" inView:self.view];
    FRProvideRequest * request = [[FRProvideRequest alloc] initWithCateID:cateID cityID:cityID mobile:mobile imgs:imgs business_license:business_license remark:remark name:name];
    [request sendRequestWithSuccess:^(BGNetworkRequest * _Nonnull request, id  _Nullable response) {
        
        [hud hideAnimated:YES];
        [MBProgressHUD showTextHUDWithText:@"上传审核成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
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

- (void)serviceTypeButtonDidClicked
{
    FRAllCateListViewController * cate = [[FRAllCateListViewController alloc] init];
    cate.delegate = self;
    [self presentViewController:cate animated:YES completion:nil];
}

#pragma mark - FRCateListViewControllerDelegate
- (void)FRAllCateListViewControllerDidChoose:(FRCateModel *)model
{
    self.chooseCateModel = model;
    self.serviceTypeLabel.text = model.name;
}

- (void)serviceRoundButtonDidClicked
{
    FRCityViewController * city = [[FRCityViewController alloc] initWithProvideChoose];
    [self.navigationController pushViewController:city animated:YES];
    city.delegate = self;
}

#pragma mark - FRCityViewControllerDelegate
- (void)FRCityViewControllerDidChoose:(FRCityModel *)model
{
    self.chooseCityModel = model;
    self.serviceRoundLabel.text = model.name;
}

- (void)createViews
{
    CGFloat scale = kMainBoundsWidth / 375.f;
    
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.backgroundColor = UIColorFromRGB(0xffffff);
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    tableView.tableFooterView = [UIView new];
    
    self.handleButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(15 * scale) titleColor:UIColorFromRGB(0xffffff) title:@"提交申请"];
    self.handleButton.backgroundColor = UIColorFromRGB(0xFA4B30);
    [self.view addSubview:self.handleButton];
    [self.handleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(45 * scale);
    }];
    [self.handleButton addTarget:self action:@selector(handleButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainBoundsWidth, 585 * scale)];
    
    UILabel * nameLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    nameLabel.text = @"名称(*必填)";
    [self.contentView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10 * scale);
        make.left.mas_equalTo(20 * scale);
        make.height.mas_equalTo(30 * scale);
        make.width.mas_equalTo(70 * scale);
    }];
    
    self.nameField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:self.nameField];
    [self.nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(nameLabel);
        make.left.mas_equalTo(nameLabel.mas_right).offset(0 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    UIButton * serviceTypeButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(10) titleColor:UIColorFromRGB(0x333333) title:@""];
    [self.contentView addSubview:serviceTypeButton];
    [serviceTypeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
    [serviceTypeButton addTarget:self action:@selector(serviceTypeButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * serviceTypeLine = [[UIView alloc] initWithFrame:CGRectZero];
    serviceTypeLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [serviceTypeButton addSubview:serviceTypeLine];
    [serviceTypeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(.5);
    }];
    
    UILabel * serviceTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    serviceTipLabel.text = @"服务类型";
    [serviceTypeButton addSubview:serviceTipLabel];
    [serviceTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.serviceTypeLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    self.serviceTypeLabel.text = @"选择服务类型";
    [serviceTypeButton addSubview:self.serviceTypeLabel];
    [self.serviceTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView * serviceTypeMore = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [serviceTypeButton addSubview:serviceTypeMore];
    [serviceTypeMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    
    UIButton * serviceRoundButton = [FRCreateViewTool createButtonWithFrame:CGRectZero font:kPingFangRegular(10) titleColor:UIColorFromRGB(0x333333) title:@""];
    [self.contentView addSubview:serviceRoundButton];
    [serviceRoundButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceTypeButton.mas_bottom);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo(50 * scale);
        make.width.mas_equalTo(kMainBoundsWidth);
    }];
    [serviceRoundButton addTarget:self action:@selector(serviceRoundButtonDidClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIView * serviceRoundLine = [[UIView alloc] initWithFrame:CGRectZero];
    serviceRoundLine.backgroundColor = UIColorFromRGB(0xcccccc);
    [serviceRoundButton addSubview:serviceRoundLine];
    [serviceRoundLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15 * scale);
        make.bottom.mas_equalTo(0);
        make.right.mas_equalTo(-15 * scale);
        make.height.mas_equalTo(.5);
    }];
    
    UILabel * serviceRoundLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    serviceRoundLabel.text = @"服务范围";
    [serviceRoundButton addSubview:serviceRoundLabel];
    [serviceRoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    self.serviceRoundLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(10 * scale) textColor:UIColorFromRGB(0x999999) alignment:NSTextAlignmentRight];
    self.serviceRoundLabel.text = @"选择服务范围";
    [serviceRoundButton addSubview:self.serviceRoundLabel];
    [self.serviceRoundLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-50 * scale);
        make.top.bottom.mas_equalTo(0);
    }];
    
    UIImageView * serviceRoundMore = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFill image:[UIImage imageNamed:@"more"]];
    [serviceRoundButton addSubview:serviceRoundMore];
    [serviceRoundMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(7);
        make.height.mas_equalTo(13);
    }];
    
    self.textView = [[RDTextView alloc] initWithFrame:CGRectZero];
    self.textView.font = kPingFangRegular(10 * scale);
    self.textView.textColor = UIColorFromRGB(0x999999);
    self.textView.placeholder = @"请简单描述申请理由与公司的资质说明（500字以内）";
    self.textView.placeholderLabel.textColor = UIColorFromRGB(0x999999);
    self.textView.placeholderLabel.font = kPingFangRegular(10 * scale);
    self.textView.maxSize = 500;
    [self.contentView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(serviceRoundButton.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 40 * scale);
        make.height.mas_equalTo(100 * scale);
    }];
    
    UIView * textLineView = [[UIView alloc] initWithFrame:CGRectZero];
    textLineView.backgroundColor = UIColorFromRGB(0xf5f5f5);
    [self.contentView addSubview:textLineView];
    [textLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(10 * scale);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(10 * scale);
    }];
    
    UILabel * cardTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    cardTipLabel.text = @"营业执照";
    [self.contentView addSubview:cardTipLabel];
    [cardTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(textLineView.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    self.cardImageView = [FRCreateViewTool createImageViewWithFrame:CGRectZero contentModel:UIViewContentModeScaleAspectFit image:[UIImage imageNamed:@"addPhoto"]];
    [self.contentView addSubview:self.cardImageView];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cardTipLabel.mas_bottom).offset(10 * scale);
        make.left.mas_equalTo(20 * scale);
        make.width.mas_equalTo(80 * scale);
        make.height.mas_equalTo(110 * scale);
    }];
    self.cardImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cardImageDidClicked)];
    [self.cardImageView addGestureRecognizer:tap];
    
    UILabel * imageTipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(12 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    imageTipLabel.text = @"其它证件";
    [self.contentView addSubview:imageTipLabel];
    [imageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cardImageView.mas_bottom).offset(15 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
    }];
    
    CGFloat width = (kMainBoundsWidth - 20 * scale) / 4.f;
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    [self.imageCollectionView registerClass:[FRImageCollectionViewCell class] forCellWithReuseIdentifier:@"FRImageCollectionViewCell"];
    self.imageCollectionView.backgroundColor = UIColorFromRGB(0xffffff);
    self.imageCollectionView.delegate = self;
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.scrollEnabled = NO;
    [self.contentView addSubview:self.imageCollectionView];
    [self.imageCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageTipLabel.mas_bottom).offset(0 * scale);
        make.left.mas_equalTo(10 * scale);
        make.width.mas_equalTo(kMainBoundsWidth - 20 * scale);
        make.height.mas_equalTo(width + 10 * scale);
    }];
    
    UILabel * mobileLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(14 * scale) textColor:UIColorFromRGB(0x333333) alignment:NSTextAlignmentLeft];
    mobileLabel.text = @"联系方式";
    [self.contentView addSubview:mobileLabel];
    [mobileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.imageCollectionView.mas_bottom).offset(5 * scale);
        make.left.mas_equalTo(15 * scale);
        make.height.mas_equalTo(20 * scale);
        make.width.mas_equalTo(70 * scale);
    }];
    
    self.mobileField = [[UITextField alloc] initWithFrame:CGRectZero];
    self.mobileField.borderStyle = UITextBorderStyleRoundedRect;
    [self.contentView addSubview:self.mobileField];
    [self.mobileField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(mobileLabel);
        make.left.mas_equalTo(mobileLabel.mas_right).offset(5 * scale);
        make.height.mas_equalTo(25 * scale);
        make.right.mas_equalTo(-50 * scale);
    }];
    
    tableView.tableHeaderView = self.contentView;
    
    [self configSelf];
}

- (void)configSelf
{
    if (self.provideModel) {
        if (self.provideModel.status == 3) {
            
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"审核未通过" message:self.provideModel.audit_remark preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * sureAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:sureAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }else{
            self.nameField.text = self.provideModel.name;
            self.serviceTypeLabel.text = self.chooseCateModel.name;
            self.serviceRoundLabel.text = self.chooseCityModel.name;
            self.mobileField.text = self.provideModel.mobile;
            
            [self loadNetWorkImage];
            
            if (self.provideModel.status == 1) {
                self.handleButton.backgroundColor = UIColorFromRGB(0xcccccc);
                [self.handleButton setTitle:@"资质审核中" forState:UIControlStateNormal];
                self.contentView.userInteractionEnabled = NO;
            }else{
                self.handleButton.backgroundColor = UIColorFromRGB(0xFA4B30);
                [self.handleButton setTitle:@"重新修改资质" forState:UIControlStateNormal];
                self.handleButton.hidden = YES;
                self.contentView.userInteractionEnabled = NO;
            }
        }
    }
}

- (void)loadNetWorkImage
{
    UIImage * cardImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.provideModel.business_license];
    if (!cardImage) {
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.provideModel.business_license] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            [self.cardImageView setImage:image];
        }];
    }else{
        [self.cardImageView setImage:cardImage];
    }
    
    NSMutableArray * imageSource = [[NSMutableArray alloc] init];
    __block NSInteger count = 0;
    for (NSInteger i = 0; i < self.provideModel.imgs.count; i++) {
        UIImage * tempImage = [UIImage new];
        [imageSource addObject:tempImage];
        
        NSString * urlStr = [self.provideModel.imgs objectAtIndex:i];
        UIImage * resultImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:urlStr];
        if (!resultImage) {
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlStr] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
                
                if (nil == image) {
                    image = [UIImage imageNamed:@"default"];
                }
                
                [imageSource replaceObjectAtIndex:i withObject:image];
                count++;
                if (count == self.provideModel.imgs.count) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.imageSource removeAllObjects];
                    [self.imageSource addObjectsFromArray:imageSource];
                    [self.imageCollectionView reloadData];
                }
            }];
        }else{
            [imageSource replaceObjectAtIndex:i withObject:resultImage];
            count++;
            if (count == self.provideModel.imgs.count) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.imageSource removeAllObjects];
                [self.imageSource addObjectsFromArray:imageSource];
                [self.imageCollectionView reloadData];
            }
        }
    }
}

- (void)cardImageDidClicked
{
    TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    picker.allowPickingOriginalPhoto = NO;
    picker.allowPickingVideo = NO;
    picker.allowTakeVideo = NO;
    picker.showSelectedIndex = NO;
    picker.allowCrop = NO;
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.imageSource.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRImageCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRImageCollectionViewCell" forIndexPath:indexPath];
    
    if (indexPath.row == self.imageSource.count) {
        
        [cell configLastCell];
        
    }else{
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        [cell configWithImage:image];
        
        __weak typeof(self) weakSelf = self;
        cell.imageDeleteHandle = ^{
            [weakSelf.imageSource removeObject:image];
            [weakSelf.imageCollectionView reloadData];
        };
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.imageSource.count) {
        
        if (self.imageSource.count == self.maxCount) {
            NSString * title = [NSString stringWithFormat:@"最多只能选择%ld张", self.maxCount];
            [MBProgressHUD showTextHUDWithText:title];
            return;
        }
        
        TZImagePickerController * picker = [[TZImagePickerController alloc] initWithMaxImagesCount:100 delegate:self];
        picker.allowPickingOriginalPhoto = NO;
        picker.allowPickingVideo = NO;
        picker.showSelectedIndex = YES;
        picker.allowCrop = NO;
        picker.maxImagesCount = self.maxCount - self.imageSource.count;
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        
        UIImage * image = [self.imageSource objectAtIndex:indexPath.item];
        LookImageViewController * look = [[LookImageViewController alloc] initWithImage:image];
        [self presentViewController:look animated:YES completion:nil];
        
    }
}

#pragma mark - 选取照片
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto infos:(NSArray<NSDictionary *> *)infos
{
    if (picker.showSelectedIndex) {
        [self.imageSource addObjectsFromArray:photos];
        [self.imageCollectionView reloadData];
    }else{
        UIImage * card = [photos firstObject];
        [self.cardImageView setImage:card];
    }
}

- (NSMutableArray *)imageSource
{
    if (!_imageSource) {
        _imageSource = [[NSMutableArray alloc] init];
    }
    return _imageSource;
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
