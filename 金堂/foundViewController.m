//
//  foundViewController.m
//  金堂
//
//  Created by zouxin on 16/3/30.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "foundViewController.h"
#import "QRCodeViewController.h"

@interface foundViewController ()

@end

@implementation foundViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    QRCodeViewController *QRCode = [self.storyboard instantiateViewControllerWithIdentifier:@"QRCode"];
  [self presentViewController:QRCode animated:YES completion:nil];
    
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
