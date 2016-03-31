//
//  QRCodeViewController.m
//  金堂
//
//  Created by zouxin on 16/3/30.
//  Copyright © 2016年 luxia. All rights reserved.
//

#import "QRCodeViewController.h"
#import "UIView+SDExtension.h"
#import "QRCodeGenerator.h"
#import <Foundation/Foundation.h>
#import <CoreImage/CoreImageDefines.h>
#import "foundViewController.h"
@import AVFoundation;
@class CIFeature;
@class CIImage;
static const CGFloat kMargin = 30;
static const CGFloat kBorderW = 100;

@interface QRCodeViewController ()<AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak)   UIView *maskView;
@property (nonatomic, strong) UIView *scanWindow;
@property (nonatomic, strong) UIImageView *scanNetImageView;
@property(nonatomic) CGRect rectOfInterest NS_AVAILABLE_IOS(7_0);

@property(nonatomic,strong) AVCaptureVideoPreviewLayer *videoLayer;

@end

@implementation QRCodeViewController
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    [self resumeAnimation];
}
-(void)viewDidDisappear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = NO;
    
}
-(void)resumeAnimation{
    CAAnimation *anim = [_scanNetImageView.layer animationForKey:@"translationAnimation"];
    if (anim) {
        // 1. 将动画的时间偏移量作为暂停时的时间点
        CFTimeInterval pauseTime = _scanNetImageView.layer.timeOffset;
        // 2. 根据媒体时间计算出准确的启动动画时间，对之前暂停动画的时间进行修正
        CFTimeInterval beginTime = CACurrentMediaTime() - pauseTime;
        
        // 3. 要把偏移时间清零
        [_scanNetImageView.layer setTimeOffset:0.0];
        // 4. 设置图层的开始动画时间
        [_scanNetImageView.layer setBeginTime:beginTime];
        
        [_scanNetImageView.layer setSpeed:1.0];
    }else{
        CGFloat scanNetImageViewH = 241;
        CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
        CGFloat scanNetImageViewW = _scanWindow.sd_width;
        
        _scanNetImageView.frame = CGRectMake(0, -scanNetImageViewH, scanNetImageViewW, scanNetImageViewH);
        CABasicAnimation *scanNetAnimation = [CABasicAnimation animation];
        scanNetAnimation.keyPath = @"transform.translation.y";
        scanNetAnimation.byValue = @(scanWindowH);
        scanNetAnimation.duration = 3.0;
        scanNetAnimation.repeatCount = MAXFLOAT;
        [_scanNetImageView.layer addAnimation:scanNetAnimation forKey:@"translationAnimation"];
        [_scanWindow addSubview:_scanNetImageView];    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.clipsToBounds = YES;
    [self setupScanWindowView];
    [self beginScanning];
    [self setupMaskView];
    [self setupBottomBar];
    [self setupTipTitleView];
    [self resumeAnimation];
    [self setupNavView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resumeAnimation) name:@"EnterForeground" object:nil];

}
-(void)setupNavView{
    [[UINavigationBar appearance]setBarTintColor:[UIColor whiteColor]];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 30, 25, 25);
    [backBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_titlebar_back_nor"] forState:UIControlStateNormal];
    backBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [backBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    
    UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    flashBtn.frame = CGRectMake(self.view.sd_width-55, 20, 35, 49);
    [flashBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    flashBtn.contentMode = UIViewContentModeScaleAspectFit;
    [flashBtn addTarget:self action:@selector(openFlash:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:flashBtn];
    
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    albumBtn.frame = CGRectMake(0, 0, 35, 49);
    albumBtn.center = CGPointMake(self.view.sd_width/2, 20 +49/2.0);
    [albumBtn setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateNormal];
    albumBtn.contentMode = UIViewContentModeScaleAspectFit;
    // [albumBtn addTarget:self action:<#(nonnull SEL)#> forControlEvents:<#(UIControlEvents)#>];
    [albumBtn addTarget:self action:@selector(myAlbum) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:albumBtn];
}
//2.相册
-(void)myAlbum{
    NSLog(@"我的相册");
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        //1.初始化相册拾取器
        UIImagePickerController *controller = [[UIImagePickerController alloc]init];
        controller.delegate = self;
        //3.设置资源：
        /**
         UIImagePickerControllerSourceTypePhotoLibrary,相册
         UIImagePickerControllerSourceTypeCamera,相机
         UIImagePickerControllerSourceTypeSavedPhotosAlbum,照片库
         */
        //4.随便给他一个转场动画
        controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        //5随便给他一个转场动画
        //controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        // controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        controller.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        
        [self presentViewController:controller animated:YES completion:NULL];
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"设备不支持访问相册，请在设置-->隐私-->照片中进行设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        
    }
}
#pragma mark -->imagePickerController delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //1.获取选择的图片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //2.初始化一个监测器
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
    [picker dismissViewControllerAnimated:YES completion:^{
        //监测到结果数组
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
        if (features.count>=1) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"扫描结果" message:scannedResult delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }else{
            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"该图片没有包含一个二维码！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }];
}

#pragma mark-->闪光灯
-(void)openFlash:(UIButton *)button{
    NSLog(@"闪光灯");
    button.selected = !button.selected;
    if (button.selected) {
        [self turnTorchOn:YES];
    }else{
        [self turnTorchOn:NO];
    }
}
#pragma mark -->开闪光灯
-(void)turnTorchOn:(BOOL)on{
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");//NSClassFromString用来对不确定的类进行初始化
    if (captureDeviceClass !=nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if ([device hasTorch]&&[device hasFlash]) {
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
            }else{
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}
-(void)click{
    //firstViewController *vc = [[firstViewController alloc]init];
    //[self presentViewController:vc animated:YES completion:nil];
    //此处试用了三种方法，上面的那种，第二种还用了初始化storyboard的那种方法，最后，才用了把第二页做成了消失才适合的，发现这世界上有解决不了的问题吗？哈哈
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
-(void)setupTipTitleView{ //1.补充遮罩
    
    UIView*mask=[[UIView alloc]initWithFrame:CGRectMake(0, _maskView.sd_y+_maskView.sd_height, self.view.sd_width, kBorderW)];
    mask.backgroundColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    [self.view addSubview:mask];
    
    //2.操作提示
    UILabel * tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.sd_height*0.9-kBorderW*2, self.view.bounds.size.width, kBorderW)];
    tipLabel.text = @"将取景框对准二维码，即可自动扫描";
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.lineBreakMode = NSLineBreakByWordWrapping;
    tipLabel.numberOfLines = 2;
    tipLabel.font=[UIFont systemFontOfSize:12];
    tipLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tipLabel];
}
-(void)setupBottomBar{
    //1.下边栏
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.sd_height * 0.8, self.view.sd_width, self.view.sd_height * 0.5)];
    bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    
    [self.view addSubview:bottomBar];
    
    //    //2.我的二维码
//        UIButton * myCodeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
//       myCodeBtn.frame = CGRectMake(0,0, self.view.sd_height * 0.1*35/49, self.view.sd_height * 0.1);
//        myCodeBtn.center=CGPointMake(self.view.sd_width/2, self.view.sd_height * 0.1/2);
//       [myCodeBtn setImage:[UIImage imageNamed:@"qrcode_scan_btn_myqrcode_down"] forState:UIControlStateNormal];
//    //
//       myCodeBtn.contentMode=UIViewContentModeScaleAspectFit;
//    //
//       [myCodeBtn addTarget:self action:@selector(myCode) forControlEvents:UIControlEventTouchUpInside];
//        [bottomBar addSubview:myCodeBtn];
}
//-(void)myCode{
//    NSLog(@"我的二维码");
//    //mycodeViewControll *vc = [[mycodeViewController alloc]init];
//    foundViewController *found = [self.storyboard instantiateViewControllerWithIdentifier:@"found"];
//    [self presentViewController:found animated:YES completion:nil];
//
//}
-(void)setupMaskView{
    UIView *mask = [[UIView alloc] init];
    _maskView = mask;
    
    mask.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor;
    mask.layer.borderWidth = kBorderW;
    
    mask.bounds = CGRectMake(0, 0, self.view.sd_width + kBorderW + kMargin , self.view.sd_width + kBorderW + kMargin);
    mask.center = CGPointMake(self.view.sd_width * 0.5, self.view.sd_height * 0.5);
    mask.sd_y = 0;
    
    [self.view addSubview:mask];}
-(void)beginScanning{ //获取后置摄像头的管理对象, Capture:捕获
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 从摄像头捕获输入流
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (error) {
        NSLog(@"error %@", error);
        return;
    }
    //  创建输出流-->把图像输入到屏幕上显示
    AVCaptureMetadataOutput *output = [AVCaptureMetadataOutput new];
    //设置代理在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //设置有效扫描区域
    // CGRect scanCrop = [self getScanCrop:_scanWindow.bounds readerViewBounds:self.view.frame];
    // output.rectOfInterest = scanCrop;
    
    
    //  需要一个管道连接输入和输出
    _session = [AVCaptureSession new];
    [_session addInput:input];
    [_session addOutput:output];
    //  管道可以规定质量,  流畅/高清/标清/高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    //#warning 设置输出流监听 二维码/条形码, 必须在管道接通之后设置!!!
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,  AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeEAN8Code];
    //把画面输入到屏幕上,给用户看
    _videoLayer=[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    //_videoLayer.frame = self.videoLayer.bounds;
    
    _videoLayer.frame = self.view.frame;
    [self.view.layer insertSublayer:_videoLayer atIndex:0];
    //[self.view.layer addSublayer:_videoLayer];
    
    //   启动管道
    [_session startRunning];
    
}
#pragma mark-> 获取扫描区域的比例关系
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [_session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"扫描结果" message:metadataObject.stringValue delegate:self cancelButtonTitle:@"退出" otherButtonTitles:@"传输到服务器成功", nil];
        
        [alert show];
        
        
        //拿扫描到的数据
        AVMetadataMachineReadableCodeObject *obj = metadataObjects.firstObject;
        NSLog(@"扫描到的数据: %@", obj.stringValue);
        
        //            NSURL *url = [NSURL URLWithString:@"http://app.cardiovascular.com.cn/API_Login/Add?code=123123"];
        //                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        //                    [request setHTTPMethod:@"POST"];
        //                    NSString *str = @"type=focus-c";
        //                    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
        //                    [request setHTTPBody:data];
        //
        //                    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        //                    NSString *str3 = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        //                    NSLog(@"%@",str3);
        //        //创建请求对象
        //        NSURL *URL = [NSURL URLWithString:@"http://app.cardiovascular.com.cn/API_Login/Add?"];
        //        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        //
        //        request.HTTPMethod = @"POST";
        //        //设置请求体
        //        NSString *param = [NSString stringWithFormat:@"code = %@",obj.stringValue];
        //        NSLog(@"code = %@",obj.stringValue);
        //        NSMutableString *str3 = [[NSMutableString alloc]initWithString:URL];
        //        [str3 insertString:param atIndex:10];
        //        NSLog(@"%@",str3);
        //        //把拼接后的字符串转换为data,设置请求体
        //        request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
        //        //[request setHTTPBody:param];
        //       // NSData *data = [NSURLConnection
        
        //sendSynchronousRequest:request returningResponse:nil error:nil];
        
        
        
        NSString *str = @"http://app.cardiovascular.com.cn/API_Login/Add?code=";
        NSString *str2 = [NSString stringWithFormat:@"%@",obj.stringValue];
        NSLog(@"str = %@,str2 = %@",str,str2);
        
        
        NSMutableString *str3  = [[NSMutableString alloc]initWithString:str];
        [str3 insertString:obj.stringValue atIndex:52];
        NSLog(@"str3 = %@",str3);
        
        NSURL *url = [NSURL URLWithString:str3];
        NSLog(@"%@",url);
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setHTTPMethod:@"POST"];
        NSString *str8 = @"type=focus-c";
        NSData *data = [str8 dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        NSString *str4= [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str4);
        
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if (buttonIndex ==1){
        [_session startRunning];
        
        
    }
}

-(void)setupScanWindowView{
    CGFloat scanWindowH = self.view.sd_width - kMargin * 2;
    CGFloat scanWindowW = self.view.sd_width - kMargin * 2;
    _scanWindow = [[UIView alloc] initWithFrame:CGRectMake(kMargin, kBorderW, scanWindowW, scanWindowH)];
    _scanWindow.clipsToBounds = YES;
    //_scanWindow.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scanWindow];
    _scanNetImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"scan_net"]];
    [_scanWindow addSubview:_scanNetImageView];
    CGFloat buttonWH = 18;
    
    UIButton *topLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, buttonWH, buttonWH)];
    [topLeft setImage:[UIImage imageNamed:@"scan_1"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topLeft];
    
    UIButton *topRight = [[UIButton alloc] initWithFrame:CGRectMake(scanWindowW - buttonWH, 0, buttonWH, buttonWH)];
    [topRight setImage:[UIImage imageNamed:@"scan_2"] forState:UIControlStateNormal];
    [_scanWindow addSubview:topRight];
    
    UIButton *bottomLeft = [[UIButton alloc] initWithFrame:CGRectMake(0, scanWindowH - buttonWH, buttonWH, buttonWH)];
    [bottomLeft setImage:[UIImage imageNamed:@"scan_3"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomLeft];
    
    UIButton *bottomRight = [[UIButton alloc] initWithFrame:CGRectMake(topRight.sd_x, bottomLeft.sd_y, buttonWH, buttonWH)];
    [bottomRight setImage:[UIImage imageNamed:@"scan_4"] forState:UIControlStateNormal];
    [_scanWindow addSubview:bottomRight];
}

@end
