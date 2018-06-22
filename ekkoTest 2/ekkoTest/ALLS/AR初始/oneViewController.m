//
//  oneViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/14.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#import "oneViewController.h"
#import "ARScanViewController.h"
@interface oneViewController ()

@end

@implementation oneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *hh = [UIButton buttonWithType:UIButtonTypeCustom];
    hh.frame = CGRectMake(80, 140, 90, 40);
    [hh setTitle:@"开启AR" forState:UIControlStateNormal];
    hh.backgroundColor = [UIColor cyanColor];
    [hh addTarget:self action:@selector(handle:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:hh];
    
}

- (void)handle:(UIButton *)sender {
    ARScanViewController *ARVC = [[ARScanViewController alloc] init];
    [self.navigationController pushViewController:ARVC animated:NO];
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
