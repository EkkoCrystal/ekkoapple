//
//  RootViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/8.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#import "RootViewController.h"
#import "SpeechViewController.h"
#import "SiriViewController.h"
#import "TableViewController.h"
#import "NAVViewController.h"
#import "oneViewController.h"
#define UIColorFromRGB(rgbValue) [UIColor  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0  green:((float)((rgbValue & 0xFF00) >> 8))/255.0  blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setup];
}
- (void)setup {
    self.tabBar.translucent = NO;
    [self addChildViewControllerWithTitle:@"语音识别" className:[NAVViewController description] icon:@"menu_23" SelectedIcon:@"menu_25"];
    [self addChildViewControllerWithTitle:@"Siri" className:[SiriViewController description] icon:@"menu_16" SelectedIcon:@"menu_18"];
    [self addChildViewControllerWithTitle:@"AR" className:[oneViewController description] icon:@"menu_16" SelectedIcon:@"menu_18"];
}

- (void)addChildViewControllerWithTitle:(NSString *)title
                              className:(NSString *)className
                                   icon:(NSString *)icon
                           SelectedIcon:(NSString *)icon_pre
{
    //处理icon照片
    UIImage *iconImage = [UIImage imageNamed:icon];
    UIImage *iconSelectedImage = [UIImage imageNamed:icon_pre];
    iconImage = [iconImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    iconSelectedImage = [iconSelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIViewController *vc = [[NSClassFromString(className) alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:iconImage selectedImage:iconSelectedImage];
    
    [self addChildViewController:nav];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
