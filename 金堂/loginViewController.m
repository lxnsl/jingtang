//
//  loginViewController.m
//  金堂
//
//  Created by zouxin on 16/3/30.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "loginViewController.h"
#import <Masonry.h>
#import "chatViewController.h"
#import "enrollViewController.h"
#import "UMSocial.h"

#define kUMKey    @"5657f8a367e58e3b660032d7"
@interface loginViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,retain)UIBarButtonItem *titleItem;



@end

@implementation loginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backgroundView.hidden = NO;
    
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
    [self setupNavView];
    
    //创建请输入用户名的那个textfield
    
    UITextField *textFieldAccount = [[UITextField alloc]init];
    textFieldAccount.backgroundColor = [UIColor clearColor];
    textFieldAccount.placeholder = @"用户名/手机号";
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
    textFieldPassword.placeholder = @"密码";
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
    //创建登录的那个按钮
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button"]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(clicklogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView1.mas_centerX);
        make.height.mas_equalTo(imageView1.mas_height).multipliedBy(0.5);
        make.top.mas_equalTo(imageView1.mas_bottom).offset(20);
        make.width.mas_equalTo(imageView1.mas_width);
        
    }];
    
    
    UIButton *enrollBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    // loginBtn.frame = CGRectMake(20, 400, 40, 80);
    enrollBtn.backgroundColor = [UIColor clearColor];
    [enrollBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
   // enrollBtn.layer.cornerRadius = 10.0;
    
    [enrollBtn setTitle:@"立即注册" forState:UIControlStateNormal];
    [enrollBtn addTarget:self action:@selector(clickEnroll:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:enrollBtn];
    [enrollBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(loginBtn.mas_left);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(10);
        
    }];
    //创建忘记密码的那个button
    
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    // loginBtn.frame = CGRectMake(20, 400, 40, 80);
    forgetBtn.backgroundColor = [UIColor clearColor];
    [forgetBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    // enrollBtn.layer.cornerRadius = 10.0;
    
    [forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [forgetBtn addTarget:self action:@selector(clickforget:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:forgetBtn];
    [forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginBtn.mas_right);
        make.top.mas_equalTo(loginBtn.mas_bottom).offset(10);
    }];
    
//创建使用第三方登录的那个图片
    UIImage *image3 = [UIImage imageNamed:@"第三方登录"];
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:image3];
    imageView3.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView3];
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(forgetBtn.mas_bottom).offset(20);
        make.width.mas_equalTo(imageView1.mas_width);
        make.height.mas_equalTo(imageView1.mas_height).multipliedBy(0.5);
    }];
    //创建使用第三方登录下的qq按钮
    
    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // loginBtn.frame = CGRectMake(20, 400, 40, 80);
    qqBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"微信"]];
  
    [qqBtn addTarget:self action:@selector(clickqq:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.centerX.mas_equalTo(imageView3.mas_centerX).offset(-20);
        make.centerX.mas_equalTo(imageView3.mas_centerX).offset(100);
        make.top.mas_equalTo(imageView3.mas_bottom).offset(20);
        //make.size.mas_equalTo(CGSizeMake(106, 107));
    }];
    //创建左边微信的那个button
    UIButton *weixinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"人人"]];
    [weixinBtn addTarget:self action:@selector(clickweixin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:weixinBtn];
    
    [weixinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(imageView3.mas_centerX).offset(-100);
        make.top.mas_equalTo(imageView3.mas_bottom).offset(20);
    }];
    
               
   }
-(void)clickqq:(UIButton *)sender{
    NSLog(@"这是你点的qq所要触发的事件");
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
    
    
}
-(void)clickweixin:(UIButton *)sender{
    NSLog(@"这是一个微信号");
    
}
//创建忘记密码的那个页面的方法
-(void)clickforget:(UIButton *)sender{
    NSLog(@"忘记密码了");
}
//创建注册的那个页面的方法
-(void)clickEnroll:(UIButton *)sender{
    NSLog(@"这是一个注册的一个页面");
    //registerViewController *register = [se];
    enrollViewController *enroll = [self.storyboard instantiateViewControllerWithIdentifier:@"enroll"];
    [self presentViewController:enroll animated:YES completion:nil];
    
    
    
    
}
-(void)clicklogin:(UIButton *)sender{
    NSLog(@"1234");
}
-(void)click{
    NSLog(@"123");
}
-(void)setupNavView{
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    backBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [backBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UILabel *label= [[UILabel alloc]init];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    label.text = @"登录";
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
    //创建立即去注册的那个按钮
    
    
    
}
//创建去登录的那个方法
-(void)click:(UIButton *)sender{
    chatViewController *chat = [self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
    [self presentViewController:chat animated:YES completion:nil];
    
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
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
