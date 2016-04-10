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
#import <SMS_SDK/SMSSDK.h>
#import "enroll2ViewController.h"
@interface enrollViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)UIView *backgroundView;
@property(nonatomic,retain)UIBarButtonItem *titleItem;

@property(nonatomic,strong)UIButton *backBtn;
//创建获取验证码的那个按钮
@property(nonatomic,strong)UIButton *getBtn;

@property(nonatomic,strong)UITextField *textFieldAccount;
@property(nonatomic,strong)UITextField *textFieldPassword;
@property(nonatomic,strong)UIImageView *imageView1;

//创建请输入验证码的那个textfield



/** 保存倒计时的时长 */
@property (nonatomic, assign) NSInteger secondsCountDown;

/** 定时器对象 */
@property (nonatomic, strong) NSTimer *countDownTimer;
//创建一个label显示输出的时间是错误的
@property(nonatomic,strong)UILabel *label;



@end

@implementation enrollViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundView.hidden = NO;
    [self setupNavView];
    _getBtn = [[UIButton alloc]initWithFrame:CGRectMake(40, 60, 70, 80)];
    _getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_getBtn setBackgroundColor:[UIColor grayColor]];
    
    [_getBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_getBtn];
    [_getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_textFieldAccount.mas_right).offset(-5);
        make.centerY.mas_equalTo(_textFieldAccount.mas_centerY);
    }];
}
-(void)setupNavView{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.frame = CGRectMake(20, 30, 25, 25);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_backBtn addTarget:self action:@selector(clickback:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backBtn];
    
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
        make.centerY.mas_equalTo(_backBtn.mas_centerY);
    }];
    
    //创建输入框的那个背景图
    UIImage *image1 = [UIImage imageNamed:@"背景框"];
    _imageView1 = [[UIImageView alloc]initWithImage:image1];
    [self.view addSubview:_imageView1];
    [_imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.mas_centerY).multipliedBy(0.65);
    }];
    //创建左边的那个用户名的图标
    UIImageView *leftVN = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon"]];
    leftVN.contentMode = UIViewContentModeCenter;
    //leftVN.frame = CGRectMake(0, 0, 55, 20);
    [_imageView1 addSubview:leftVN];
    [leftVN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageView1.mas_centerY).multipliedBy(0.5);
        
        
        make.left.mas_equalTo(_imageView1.mas_left).offset(10);
    }];

    UIImageView *leftVP = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"lock"]];
    leftVP.contentMode = UIViewContentModeCenter;
    [self.view addSubview:leftVP];
    [leftVP mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_imageView1.mas_centerY).offset(22);
        make.left.mas_equalTo(_imageView1.mas_left).offset(10);
    }];
    //创建请输入手机号码的那个textfield
    _textFieldAccount = [[UITextField alloc]init];
    _textFieldAccount.backgroundColor = [UIColor clearColor];
    _textFieldAccount.placeholder = @"请输入手机号码";
    _textFieldAccount.textAlignment = UITextAlignmentCenter;

    _textFieldAccount.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldAccount.font = [UIFont systemFontOfSize:18];
    _textFieldAccount.adjustsFontSizeToFitWidth = YES;
    _textFieldAccount.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldAccount.returnKeyType = UIReturnKeyDone;//设置键盘的完成按钮
    
    _textFieldAccount.delegate = self;
   // [_textFieldAccount addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textFieldAccount];
    [_textFieldAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_imageView1.mas_centerX);
        make.width.mas_equalTo(_imageView1.mas_width);
        make.top.mas_equalTo(_imageView1.mas_top);
        make.height.mas_equalTo(_imageView1.mas_height).multipliedBy(0.5);
        
    }];
    
    //创建输入用户名的那个textfieldPassword
    
    _textFieldPassword = [[UITextField alloc]init];
    _textFieldPassword.backgroundColor = [UIColor clearColor];
    _textFieldPassword.placeholder = @"请输入短信验证码";
    _textFieldPassword.textAlignment = UITextAlignmentCenter;
    _textFieldPassword.borderStyle = UITextBorderStyleRoundedRect;
    _textFieldPassword.font = [UIFont systemFontOfSize:18];
    _textFieldPassword.adjustsFontSizeToFitWidth = YES;
    _textFieldPassword.keyboardType = UIKeyboardTypeNumberPad;
    _textFieldPassword.returnKeyType = UIReturnKeyDone;//设置键盘的完成按钮
    
    _textFieldPassword.delegate = self;
    [_textFieldPassword addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_textFieldPassword];
    [_textFieldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_imageView1.mas_width);
        make.centerX.mas_equalTo(_imageView1.mas_centerX);
        make.height.mas_equalTo(_imageView1.mas_height).multipliedBy(0.5);
        make.bottom.mas_equalTo(_imageView1.mas_bottom);
    }];
    
    
    //创建下一步这个按钮
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"button"]];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(clicknext:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_imageView1.mas_centerX);
        make.height.mas_equalTo(_imageView1.mas_height).multipliedBy(0.5);
        make.top.mas_equalTo(_imageView1.mas_bottom).offset(20);
        make.width.mas_equalTo(_imageView1.mas_width);
        
    }];


}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(nonnull NSString *)string{
    NSString *toString = _textFieldAccount.text;
    if (toString.length <10||toString.length>10) {
        NSLog(@"123455");
        
        _getBtn.backgroundColor = [UIColor grayColor];
        _getBtn.userInteractionEnabled = NO;
        [_getBtn addTarget:self action:@selector(clickgetCode) forControlEvents:UIControlEventTouchUpInside];
    }else if(toString.length ==10){
        _getBtn.backgroundColor = [UIColor greenColor];
        
        _getBtn.userInteractionEnabled = YES;
        [_getBtn addTarget:self action:@selector(clickgetCode2) forControlEvents:UIControlEventTouchUpInside];
        
        //_secondsCountDown = 10;
        
//        //设置倒计时显示时间
//        _getBtn.titleLabel.text =[NSString stringWithFormat:@"%ld",(long)_secondsCountDown];
//
//        _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        
        
          }
    
    return YES;
    
}
-(void)clickgetCode{
    NSLog(@"这是不可点");
}
//这个状态是可点，也是可以获取验证码的那个按钮的点击的方法
-(void)clickgetCode2{
   
    NSLog(@"这是可点的正确的状态");
    NSString *codeString = _textFieldAccount.text;
    NSLog(@"codeString是:%@",codeString);
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:codeString zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (error) {
            NSLog(@"手机号码是错误的error %@", error);
            _label = [[UILabel alloc]init];
            _label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
            _label.text = @"请输入正确的手机号码格式!";
            _label.textColor = [UIColor redColor];
            _label.font = [UIFont fontWithName:@"AmericanTypewriter" size:18];
            _label.numberOfLines = 1;
            [_label sizeToFit];
            
            _label.adjustsFontSizeToFitWidth = YES;
            _label.userInteractionEnabled = YES;
            
            [self.view addSubview:_label];
            [_label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(_textFieldAccount.mas_centerX);
                make.bottom.mas_equalTo(_textFieldAccount.mas_top).offset(2);
            
            }];
        
        }else{
            //创建验证码
            NSLog(@"验证码发送成功!");
            
            //定时器验证码将会在10s内发送给你
            _secondsCountDown = 10;
            _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
        }
    }];
}
-(void)timeFireMethod{
    //倒计时-1
    _secondsCountDown = 10;
    _secondsCountDown--;
   // _secondsCountDown = _secondsCountDown--;
    
    //修改倒计时显示时标签要实现的内容
    _getBtn.titleLabel.text = [NSString stringWithFormat:@"%ld验证码会在60s之内发送给你",_secondsCountDown];
    _getBtn.titleLabel.lineBreakMode =NSLineBreakByWordWrapping;
    _getBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    
    if (_secondsCountDown == 0) {
        [_countDownTimer invalidate];
        
        //[_getBtn.titleLabel removeFromSuperview];
        _getBtn.titleLabel.text = @"验证码已发送";
    }
}

-(void)clicknext:(UIButton *)sender{
    NSLog(@"点击跳转到下一步用户注册用户信息");
    NSString *codeString = _textFieldAccount.text;
    NSLog(@"codeString是:%@",codeString);
    [SMSSDK commitVerificationCode:@"12" phoneNumber:codeString zone:@"86" result:^(NSError *error) {
        if (error) {
            NSLog(@"error %@", error);
            
            enroll2ViewController *enroll2 = [self.storyboard instantiateViewControllerWithIdentifier:@"enroll2"];
//            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:enroll2];
            [self presentViewController:enroll2 animated:YES completion:nil];

        }else{
            NSLog(@"验证成功!");
                    }
    }];
    
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
