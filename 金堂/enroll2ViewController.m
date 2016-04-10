//
//  enroll2ViewController.m
//  金堂
//
//  Created by zouxin on 16/4/7.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "enroll2ViewController.h"
#import <Masonry.h>
#import "enrollViewController.h"
@interface enroll2ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UIButton *backBtn;
//@property(nonatomic,strong)UIBarButtonItem *rightItem;
@property(nonatomic,strong)UIView *backgroundView;

@property(nonatomic,strong)UITextField *textField1;

@property(nonatomic,strong)UITextField *textField2;

@property(nonatomic,strong)UITextField *textField3;
@end

@implementation enroll2ViewController

-(UIView *)backgroundView{
    if (_backgroundView ==nil) {
        _backgroundView = [[UIView alloc]init];
        _backgroundView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:_backgroundView];
        [_backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];

    }
    return _backgroundView;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backgroundView.hidden = NO;
//    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    
    [[UINavigationBar appearance]setBarTintColor:[UIColor redColor]];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    _backBtn.frame = CGRectMake(20, 30, 25, 25);
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    _backBtn.contentMode = UIViewContentModeScaleAspectFill;
    [_backBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    
     [self.view addSubview:_backBtn];
    
    //UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1; //3个分区，默认是1
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}
//每一行显示什么样式
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [UITableViewCell new];
    //cell.textLabel.text = @"你好";
    cell.backgroundColor = [UIColor blueColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row ==0) {
        
        UIImage *image = [UIImage imageNamed:@"dongtai"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor whiteColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        }];
        
        
        _textField1 = [[UITextField alloc]init];
        _textField1.backgroundColor = [UIColor redColor];
        _textField1.placeholder = @"用户名";
        //_textField1.textAlignment = UITextAlignmentCenter;
        _textField1.textAlignment = UITextAlignmentLeft;
        _textField1.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField1.font = [UIFont systemFontOfSize:25];
        _textField1.adjustsFontSizeToFitWidth = YES;
        _textField1.keyboardType = UIKeyboardTypeNumberPad;
        _textField1.returnKeyType = UIReturnKeyDone;
        _textField1.delegate = self;
        
        
        [cell.contentView addSubview:_textField1];
        
        [_textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(imageView.mas_right).offset(5);
            make.height.mas_equalTo(cell.contentView.mas_height);
            make.width.mas_equalTo(cell.contentView.mas_width);
            
        }];
    }else if (indexPath.row ==1){
        
        UIImage *image = [UIImage imageNamed:@"dongtai"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor whiteColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        }];
        
        
        _textField2 = [[UITextField alloc]init];
        _textField2.backgroundColor = [UIColor redColor];
        _textField2.placeholder = @"密码[至少6位，含字母和数字]";
        //_textField1.textAlignment = UITextAlignmentCenter;
        _textField2.textAlignment = UITextAlignmentLeft;
        _textField2.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField2.font = [UIFont systemFontOfSize:25];
        _textField2.adjustsFontSizeToFitWidth = YES;
        _textField2.keyboardType = UIKeyboardTypeNumberPad;
        _textField2.returnKeyType = UIReturnKeyDone;
        _textField2.delegate = self;
        
        
        [cell.contentView addSubview:_textField2];
        
        [_textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(imageView.mas_right).offset(5);
            make.height.mas_equalTo(cell.contentView.mas_height);
            make.width.mas_equalTo(cell.contentView.mas_width);
            
        }];

    
    }else if (indexPath.row == 2){
        
        UIImage *image = [UIImage imageNamed:@"dongtai"];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        [cell.contentView addSubview:imageView];
        cell.backgroundColor = [UIColor whiteColor];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.contentView.mas_left).offset(10);
            make.centerY.mas_equalTo(cell.contentView.mas_centerY);
        }];

        _textField3 = [[UITextField alloc]init];
        _textField3.backgroundColor = [UIColor redColor];
        _textField3.placeholder = @"确认密码";
        //_textField1.textAlignment = UITextAlignmentCenter;
        _textField3.textAlignment = UITextAlignmentLeft;
        _textField3.borderStyle = UITextBorderStyleRoundedRect;
        
        _textField3.font = [UIFont systemFontOfSize:25];
        _textField3.adjustsFontSizeToFitWidth = YES;
        _textField3.keyboardType = UIKeyboardTypeNumberPad;
        _textField3.returnKeyType = UIReturnKeyDone;
        _textField3.delegate = self;
        
        
        [cell.contentView addSubview:_textField3];
        
        [_textField3 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(imageView.mas_right).offset(5);
            make.height.mas_equalTo(cell.contentView.mas_height);
            make.width.mas_equalTo(cell.contentView.mas_width);
            
        }];
        
    }else if (indexPath.row ==3){
        
        //UIImage *image = [UIImage imageNamed:@"dongtai"];
        
        
        
        
    }
    return cell;
}
-(void)click:(UIButton *)sender{
    enrollViewController *enroll = [self.storyboard instantiateViewControllerWithIdentifier:@"enroll"];
    [self presentViewController:enroll animated:YES completion:nil];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.view.frame.size.height/10;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

@end
