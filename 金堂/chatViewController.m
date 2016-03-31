//
//  chatViewController.m
//  金堂
//
//  Created by zouxin on 16/3/29.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "chatViewController.h"
#import <Masonry.h>
#import "loginViewController.h"
@interface chatViewController ()

@end

@implementation chatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建一个button覆盖聊天的那个界面
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //创建微笑的那个圆脸的uiimageView
    UIImage *image = [UIImage imageNamed:@"头像"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY);
    }];
    //创建登录后去和朋友们聊天吧的那个label
    UILabel *label = [[UILabel alloc]init];
    label.text = @"登录后去和朋友聊天吧";
    
    label.textColor = [UIColor grayColor];
    label.textAlignment = UITextAlignmentCenter;
    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont fontWithName:@"HiraKakuProN-w3" size:18];
    label.numberOfLines = 1;
    [label sizeToFit];
    label.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(imageView.mas_bottom).offset(10);
    }];
//创建去登录的那个按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    // loginBtn.frame = CGRectMake(20, 400, 40, 80);
    loginBtn.backgroundColor = [UIColor colorWithRed:0 green:166.0/255 blue:255.0/255 alpha:1];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    loginBtn.layer.cornerRadius = 10.0;
    
    [loginBtn setTitle:@"去登录" forState:UIControlStateNormal];
    [loginBtn setTitle:@"去登录" forState:UIControlStateHighlighted];
    [loginBtn addTarget:self action:@selector(clicklogin:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(label.mas_width);
        //make.height.mas_equalTo(self.navigationController.navigationBar.mas_height);
        make.height.mas_equalTo(30);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(label.mas_bottom).offset(8);
    
    }];
    //创建导航栏右上角的那个具有二维码扫描功能的按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dongtai"] style:UIBarButtonItemStylePlain target:self action:@selector(clickQRCode:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    ////创建导航栏左上角的那个具有二维码扫描功能的按钮
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"dongtai"] style:UIBarButtonItemStylePlain target:self action:@selector(clickVIP:)];
    self.navigationItem.leftBarButtonItem = leftButton;

}
-(void)clickVIP:(UIBarButtonItem *)sender{
    NSLog(@"输出的是人的头像");
}
-(void)clickQRCode:(UIBarButtonItem *)sender{
    NSLog(@"点击了后就会产生二维码扫描功能");
    
    
    
}
-(void)clicklogin:(UIButton *)sender{
    NSLog(@"你点对了，我擦");
    loginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:login animated:YES completion:nil];
    
    
    
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
