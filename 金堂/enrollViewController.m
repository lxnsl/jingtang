//
//  enrollViewController.m
//  金堂
//
//  Created by zouxin on 16/3/30.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "enrollViewController.h"
#import <Masonry.h>
#import "loginViewController.h"
@interface enrollViewController ()
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,retain)UIBarButtonItem *titleItem;
@end

@implementation enrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView.hidden = NO;
    [self setupNavView];

}
-(void)setupNavView{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    backBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [backBtn addTarget:self action:@selector(clickback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *label= [[UILabel alloc]init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    label.text = @"注册";
    label.textColor = [UIColor whiteColor];
    //    label.textAlignment = UITextAlignmentCenter;
    //    label.lineBreakMode = UILineBreakModeWordWrap;
    label.font = [UIFont fontWithName:@"AmericanTypewriter" size:18];
    label.numberOfLines = 1;
    
    [label sizeToFit];
    label.adjustsFontSizeToFitWidth = YES;
    label.userInteractionEnabled = YES;
    //self.navigationItem.title = label;
    self.navigationItem.titleView = label;
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(backBtn.mas_centerY);
    }];
    
    //创建输入框的那个背景图
    UIImage *image1 = [UIImage imageNamed:@"背景框"];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:image1];
    [self.view addSubview:imageView1];
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).multipliedBy(0.65);
    }];
    //创建左边的那个用户名的图标
    UIImageView *leftVN = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    leftVN.contentMode = UIViewContentModeCenter;
    //leftVN.frame = CGRectMake(0, 0, 55, 20);
    [imageView1 addSubview:leftVN];
    [leftVN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView1.mas_centerY).multipliedBy(0.5);
        
        
        make.left.mas_equalTo(imageView1.mas_left).offset(10);
    }];

    UIImageView *leftVP = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lock"]];
    leftVP.contentMode = UIViewContentModeCenter;
    [self.view addSubview:leftVP];
    [leftVP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(imageView1.mas_centerY).offset(22);
        make.left.mas_equalTo(imageView1.mas_left).offset(10);
    }];
    //创建请输入手机号码的那个textfield
    UITextField *textFieldAccount = [[UITextField alloc]init];
    textFieldAccount.backgroundColor = [UIColor clearColor];
    textFieldAccount.placeholder = @"请输入手机号码";
    textFieldAccount.textAlignment = UITextAlignmentCenter;
    textFieldAccount.borderStyle = UITextBorderStyleRoundedRect;
    textFieldAccount.font = [UIFont systemFontOfSize:18];
    textFieldAccount.adjustsFontSizeToFitWidth = YES;
    textFieldAccount.keyboardType = UIKeyboardTypeNumberPad;
    textFieldAccount.returnKeyType = UIReturnKeyDone;//设置键盘的完成按钮
    
    textFieldAccount.delegate = self;
    [textFieldAccount addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textFieldAccount];
    [textFieldAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView1.mas_centerX);
        make.width.mas_equalTo(imageView1.mas_width);
        make.top.mas_equalTo(imageView1.mas_top);
        make.height.mas_equalTo(imageView1.mas_height).multipliedBy(0.5);
        
    }];
    
    //创建输入用户名的那个textfieldPassword
    
    UITextField *textFieldPassword = [[UITextField alloc]init];
    textFieldPassword.backgroundColor = [UIColor clearColor];
    textFieldPassword.placeholder = @"请输入短信验证码";
    textFieldPassword.textAlignment = UITextAlignmentCenter;
    textFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
    textFieldPassword.font = [UIFont systemFontOfSize:18];
    textFieldPassword.adjustsFontSizeToFitWidth = YES;
    textFieldPassword.keyboardType = UIKeyboardTypeNumberPad;
    textFieldPassword.returnKeyType = UIReturnKeyDone;//设置键盘的完成按钮
    
    textFieldPassword.delegate = self;
    [textFieldPassword addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textFieldPassword];
    [textFieldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(imageView1.mas_width);
        make.centerX.mas_equalTo(imageView1.mas_centerX);
        make.height.mas_equalTo(imageView1.mas_height).multipliedBy(0.5);
        make.bottom.mas_equalTo(imageView1.mas_bottom);
    }];
    
    
    //创建下一步这个按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button"]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clicknext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView1.mas_centerX);
        make.height.mas_equalTo(imageView1.mas_height).multipliedBy(0.5);
        make.top.mas_equalTo(imageView1.mas_bottom).offset(20);
        make.width.mas_equalTo(imageView1.mas_width);
        
    }];


}
-(void)clicknext:(UIButton *)sender{
    NSLog(@"");
}
//backgroundview
-(UIView *)backgroundView{
    if (_backgroundView ==nil) {
        _backgroundView = [[UIView alloc]init];
        //_backgroundView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        _backgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"背景图"]];
        [self.view addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        
    }
    return _backgroundView;
}
-(void)clickback:(UIButton *)sender{
    loginViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login"];
    [self presentViewController:login animated:YES completion:nil];

}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


@end
