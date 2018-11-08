//
//  ViewController.m
//  GuideViewController
//
//  Created by 发兵 杨 on 12-9-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SplashViewController.h"
#import "AppDelegate.h"
#import <Masonry.h>
#import "FRCreateViewTool.h"

@interface SplashViewController()<UIScrollViewDelegate>
{
    NSArray*                _imageArray ;
}
@property (retain, nonatomic) IBOutlet UIScrollView *pageScroll;
@property (strong, nonatomic) UIView *pageView;

@end
@implementation SplashViewController

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _imageArray = [self createImageArray];
    [self createImageViews];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
-(NSArray*)createImageArray
{
    NSInteger count = 4;
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < count; i ++)
    {
        NSString *imageName = [NSString stringWithFormat:@"index_%d.jpg",i];
        UIImage *image = [self imageAtApplicationDirectoryWithName:imageName];
        [imageArray addObject:image];
    }
    return imageArray;
}

//获取NSBundele中的资源图片
- (UIImage *)imageAtApplicationDirectoryWithName:(NSString *)fileName {
    if(fileName) {
        NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
        path = [NSString stringWithFormat:@"%@.%@",path,[fileName pathExtension]];
        if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            path = nil;
        }
        
        if(!path) {
            path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:fileName];
        }
        return [UIImage imageWithContentsOfFile:path];
    }
    return nil;
}


-(void)createImageViews
{
    _pageView = [[UIView alloc] init];
    _pageView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_pageView];
    [_pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(65,3));
        make.bottom.mas_equalTo(- 20);
        make.centerX.mas_equalTo(0);
    }];
    
    NSInteger count = _imageArray.count;
    if (count > 0)
    {
        _pageScroll.contentSize = CGSizeMake(kMainBoundsWidth*count, _pageScroll.frame.size.height);
        for (int i = 0; i < _imageArray.count; i ++)
        {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(kMainBoundsWidth*i, 0, kMainBoundsWidth, kMainBoundsHeight)];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.image = [_imageArray objectAtIndex:i];
            [_pageScroll addSubview:imageView];
            imageView.userInteractionEnabled = YES;
            if(i==count-1){
                UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                sureBtn.backgroundColor = [UIColor clearColor];
                sureBtn.frame = CGRectZero;
                sureBtn.layer.cornerRadius = 2.0;
                sureBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
                sureBtn.layer.borderWidth = 1.0f;
                [sureBtn setTitle:@"立即体验" forState:UIControlStateNormal];
                [sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [sureBtn.titleLabel setFont:kPingFangLight(16)];
                [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:sureBtn];
                
                [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(88,30));
                    make.bottom.mas_equalTo(-kMainBoundsHeight / 5.f);
                    make.centerX.mas_equalTo(0);
                }];
                
                UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(16) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentCenter];
                tipLabel.text = @"统一标准化服务";
                [imageView addSubview:tipLabel];
                [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(20);
                    make.left.right.mas_equalTo(0);
                    make.bottom.mas_equalTo(-kMainBoundsHeight/5.f - 50);
                }];
            }else{
                UIButton* sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                sureBtn.backgroundColor = [UIColor clearColor];
                sureBtn.frame = CGRectZero;
                sureBtn.layer.cornerRadius = 12.0;
                sureBtn.layer.borderColor = UIColorFromRGB(0xffffff).CGColor;
                sureBtn.layer.borderWidth = 1.0f;
                [sureBtn setTitle:@"跳过" forState:UIControlStateNormal];
                [sureBtn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
                [sureBtn.titleLabel setFont:kPingFangLight(13)];
                [sureBtn addTarget:self action:@selector(sureBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
                [imageView addSubview:sureBtn];
                
                [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(50,24));
                    make.top.mas_equalTo(40);
                    make.right.mas_equalTo(-30);
                }];
                
                if (i == 0) {
                    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(16) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentCenter];
                    tipLabel.text = @"快速寻找行业解决方案";
                    [imageView addSubview:tipLabel];
                    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(20);
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(-kMainBoundsHeight/5.f - 50);
                    }];
                }else{
                    UILabel * tipLabel = [FRCreateViewTool createLabelWithFrame:CGRectZero font:kPingFangRegular(16) textColor:UIColorFromRGB(0xffffff) alignment:NSTextAlignmentCenter];
                    tipLabel.text = @"积分与会员等级折扣商城优惠力度大";
                    [imageView addSubview:tipLabel];
                    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(20);
                        make.left.right.mas_equalTo(0);
                        make.bottom.mas_equalTo(-kMainBoundsHeight/5.f - 50);
                    }];
                }
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    // 设置选中View背景色
    for (UILabel *label in [_pageView subviews]) {
        if (label.tag == page + 1000) {
            label.backgroundColor = UIColorFromRGB(0x902d3f);
        }else{
            label.backgroundColor = UIColorFromRGB(0xddc8c4);
        }
    }
}

-(void)sureBtnClicked:(id)sender
{
    
    if ([_delegate respondsToSelector:@selector(splashViewControllerSureBtnClicked)]) {
        [_delegate splashViewControllerSureBtnClicked];
    }
}

//允许屏幕旋转
- (BOOL)shouldAutorotate
{
    return YES;
}

//返回当前屏幕旋转方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
