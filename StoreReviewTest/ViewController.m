//
//  ViewController.m
//  StoreReviewTest
//
//  Created by 惠上科技 on 2018/12/25.
//  Copyright © 2018 惠上科技. All rights reserved.
//

#import "ViewController.h"
#import <StoreKit/StoreKit.h>
@interface ViewController ()<SKStoreProductViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}



/**
 应用内评分
 
 只能评分，不能编写评论
 有次数限制，一年只能使用三次
 使用次数超限g后，需要跳转appstore
 */
- (IBAction)systemComentBtnAction:(UIButton *)sender {
    if (@available(iOS 10.3, *)) {
        //防止键盘遮挡
        [[UIApplication sharedApplication].keyWindow endEditing:YES];
        [SKStoreReviewController requestReview];
    }else{
        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"❌❌最低要求10.3系统❌❌" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alterView show];
    }
}



/**
 跳转到AppStore对应应用评论页面

 可评分评论，无次数限制
 */
- (IBAction)appStoreComentBtnAction:(UIButton *)sender {
    NSString *nsStringToOpne = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@?action=write-review",@"1216065175"];//替换为对应的APPID
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:nsStringToOpne] options:@{} completionHandler:nil];
}


/**
 iOS 6.0以后的方法，内部加载AppStore
 
 * 在APP内部加载App Store 展示APP信息，但不能直接跳转到评论编辑页面。
 * 再加载处App Store展示页面后，需要手动点击 评论→ 撰写评论
 */
- (IBAction)webAppStoreBtnAction:(UIButton *)sender {
    SKStoreProductViewController *storeProductViewContorller = [[SKStoreProductViewController alloc] init];
    storeProductViewContorller.delegate = self;
    //加载App Store视图展示
    [storeProductViewContorller loadProductWithParameters:
     @{SKStoreProductParameterITunesItemIdentifier : @"1216065175"} completionBlock:^(BOOL result, NSError *error) {
         if(error) {
         } else {
             //模态弹出appstore
             [self presentViewController:storeProductViewContorller animated:YES completion:^{
             }];
         }
     }];
}


// 代理方法
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

@end
