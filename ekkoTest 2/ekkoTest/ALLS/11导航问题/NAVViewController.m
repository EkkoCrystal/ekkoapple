//
//  NAVViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/10.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#import "NAVViewController.h"
#import "UIColor+ColorUtility.h"
@interface NAVViewController ()

@end

@implementation NAVViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"长远";
    
    self.navigationController.navigationBar.barTintColor = [UIColor redColor];
    
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editHandle)];
    UIBarButtonItem *hhItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"x14.png"] style:UIBarButtonItemStylePlain target:self action:@selector(uuHandle)];
    self.navigationItem.rightBarButtonItems = @[hhItem, editItem];
    
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:nil];
    UIBarButtonItem *jjItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    self.navigationItem.leftBarButtonItems = @[jjItem];
    
    UISearchBar *hhBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = hhBar;
}
- (void)editHandle {
    NSLog(@"ss");
}
- (void)uuHandle {
    NSLog(@"oooo");
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
