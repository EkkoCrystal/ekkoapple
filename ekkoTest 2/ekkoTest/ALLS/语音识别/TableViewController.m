//
//  TableViewController.m
//  ekkoTest
//
//  Created by ekko on 2018/5/9.
//  Copyright © 2018年 ekkoProduct. All rights reserved.
//

#import "TableViewController.h"
#import <AudioToolbox/AudioToolbox.h>
#define kScreenWith             [UIScreen mainScreen].bounds.size.width
#define kScreenHeight           [UIScreen mainScreen].bounds.size.height

@interface TableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

static NSString *const reuseIdentifier = @"reuseCell";

@implementation TableViewController
- (UITableView *)tableView {
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWith, kScreenHeight - 64)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    }
    return _tableView;
}
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        self.dataSource = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    [self getSystemSound];
    
}
- (void)getSystemSound {
    NSFileManager *fileManage = [[NSFileManager alloc] init];
    NSURL *directorURL = [NSURL URLWithString:@"/System/Library/Audio"];
    NSArray *key = [NSArray arrayWithObject:NSURLIsDirectoryKey];
    NSDirectoryEnumerator *enumerator = [fileManage enumeratorAtURL:directorURL includingPropertiesForKeys:key options:0 errorHandler:^BOOL(NSURL * _Nonnull url, NSError * _Nonnull error) {
        return YES;
    }];
    for (NSURL *url in enumerator) {
        NSError *error;
        NSNumber *isDirrctory = nil;
        if (![url getResourceValue:&isDirrctory forKey:NSURLIsDirectoryKey error:&error]) {
            NSLog(@"");
        } else if (![isDirrctory boolValue]) {
            [self.dataSource addObject:url];
        } else {
            [self.tableView reloadData];
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[self.dataSource objectAtIndex:indexPath.row] lastPathComponent];
    cell.detailTextLabel.text = @"";
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)[self.dataSource objectAtIndex:indexPath.row], &soundID);
    AudioServicesPlayAlertSound(soundID);
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
