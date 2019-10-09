//
//  PlateMainController.m
//  PlateDemo
//
//  Created by ocrgroup on 2018/3/9.
//  Copyright © 2018年 DXY. All rights reserved.
//

#import "PlateMainController.h"
#import "PlateCameraController.h"
#import "SPlate.h"

static inline BOOL isIPhoneXSeries() {
    BOOL iPhoneXSeries = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {
        return iPhoneXSeries;
    }
    
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneXSeries = YES;
        }
    }
    return iPhoneXSeries;
}

//底部安全区
#define SafeAreaBottomHeight (isIPhoneXSeries() ? 24 : 0)

#define SCREENH [UIScreen mainScreen].bounds.size.height
#define SCREENW [UIScreen mainScreen].bounds.size.width

@interface PlateMainController () <PlateCameraDelegate>

@property (nonatomic, strong) UIButton * scanPlate;

@property (nonatomic, strong) UILabel * scanLabel;

@property (nonatomic, strong) UIImageView * plateImageView;

@property (nonatomic, strong) UILabel * resultLabel;


@property (nonatomic, strong) UILabel * versionLabel;

@end

@implementation PlateMainController {
    NSString * _authorizationCode ; //授权码
}

- (instancetype)initWithAuthorizationCode:(NSString *)authorizationCode {
    if (self = [super init]) {
        _authorizationCode = authorizationCode;
        _authorizationCode = @"9DD232F7B4C7398BA6C2";
    }
    return self;
}

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

//是否可以旋转
- (BOOL)shouldAutorotate {
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:52./255. green:167./255. blue:217./255. alpha:1];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    [self prepareUI];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)prepareUI {
    
    self.title = @"车牌码识别";
    
    [self.view addSubview:self.scanPlate];
    
    [self.view addSubview:self.scanLabel];
    
    [self.view addSubview:self.plateImageView];
    
    [self.view addSubview:self.resultLabel];
    
    
    [self.view addSubview:self.versionLabel];
    
    [self frameSetup];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self frameSetup];
}

- (void)frameSetup {
    
    self.plateImageView.frame = CGRectMake(SCREENW * 0.5 - 150, 40, 300, 90);
    self.plateImageView.layer.cornerRadius = 5;
    self.plateImageView.layer.masksToBounds = YES;
    
    self.resultLabel.frame = CGRectMake(0, 0, 300, 100);
    self.resultLabel.center = CGPointMake(SCREENW * 0.5, CGRectGetMaxY(self.plateImageView.frame) + 65);
    
    self.scanPlate.frame = CGRectMake(SCREENW * 0.5 - 30, SCREENH - CGRectGetMaxY(self.navigationController.navigationBar.frame) - 90 - SafeAreaBottomHeight, 60, 60);
    
    self.scanLabel.frame = CGRectMake(0, 0, 150, 25);
    self.scanLabel.center = CGPointMake(self.scanPlate.center.x, CGRectGetMaxY(self.scanPlate.frame) + 20);
    
    
    [self.versionLabel sizeToFit];
    self.versionLabel.center = CGPointMake(SCREENW * 0.5, CGRectGetMinY(self.scanPlate.frame) - 24);
    
}

#pragma mark - 点击事件
- (void)scanPlateButtonClick {
    PlateCameraController * cameraController = [[PlateCameraController alloc] initWithAuthorizationCode:_authorizationCode];
    cameraController.delegate = self;
    cameraController.deviceDirection = self.preferredInterfaceOrientationForPresentation;
    [self presentViewController:cameraController animated:YES completion:nil];
}

#pragma mark - 识别结果回调
- (void)cameraController:(UIViewController *)cameraController recognizePlateSuccessWithResult:(NSString *)plateStr plateColor:(NSString *)plateColor plateImage:(UIImage *)plateImage squareImage:(UIImage *)squareImage andFullImage:(UIImage *)fullImage {
    [cameraController dismissViewControllerAnimated:YES completion:nil];
    self.plateImageView.image = plateImage;
    self.resultLabel.text = [NSString stringWithFormat:@"%@\n%@",plateStr,plateColor];
    self.actionBlock(plateStr);
    NSLog(@"%@ %@",plateStr,plateColor);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIButton *)scanPlate {
    if (!_scanPlate) {
        _scanPlate = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage * scanImage = [UIImage imageNamed:@"scan"];
        [_scanPlate setImage:scanImage forState:UIControlStateNormal];
        [_scanPlate addTarget:self action:@selector(scanPlateButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _scanPlate;
}

- (UILabel *)scanLabel {
    if (!_scanLabel) {
        _scanLabel = [[UILabel alloc] init];
        _scanLabel.text = @"扫描识别车牌";
        _scanLabel.font = [UIFont systemFontOfSize:18];
        _scanLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _scanLabel;
}

- (UIImageView *)plateImageView {
    if (!_plateImageView) {
        UIImage * carImage = [UIImage imageNamed:@"car"];
        _plateImageView = [[UIImageView alloc] initWithImage:carImage];
        _plateImageView.backgroundColor = [UIColor whiteColor];
        _plateImageView.contentMode = UIViewContentModeScaleAspectFit;
        _plateImageView.layer.borderColor = [UIColor grayColor].CGColor;
        _plateImageView.layer.borderWidth = 1;
    }
    return _plateImageView;
}

- (UILabel *)resultLabel {
    if (!_resultLabel) {
        _resultLabel = [[UILabel alloc] init];
        _resultLabel.font = [UIFont systemFontOfSize:40];
        _resultLabel.textAlignment = NSTextAlignmentCenter;
        _resultLabel.numberOfLines = 0;
    }
    return _resultLabel;
}

- (UILabel *)versionLabel {
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.textColor = [UIColor lightGrayColor];
        SPlate * plateKernal = [[SPlate alloc] init];
        NSString * sdkVersion = plateKernal.sdkVersion;
        PlateCameraController * cameraVC = [[PlateCameraController alloc] init];
        NSString * demoVersion = cameraVC.codeVersion;
        _versionLabel.text = [NSString stringWithFormat:@"Demo版本：%@ SDK版本：%@", demoVersion, sdkVersion];
        _versionLabel.font = [UIFont systemFontOfSize:13];
    }
    return _versionLabel;
}

@end
