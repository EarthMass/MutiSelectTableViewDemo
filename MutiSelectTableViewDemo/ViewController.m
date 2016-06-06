//
//  ViewController.m
//  MutiSelectTableViewDemo
//
//  Created by Guohx on 16/6/2.
//  Copyright © 2016年 guohx. All rights reserved.
//

#import "ViewController.h"
#import "MutiTableViewVC.h"

@interface ViewController () {
    MutiTableViewVC * tableVC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self navInit];
    
    // Do any additional setup after loading the view, typically from a nib.
    tableVC = [[MutiTableViewVC alloc] init];
    
//    [self addChildViewController:tableVC];
    [self.view addSubview:tableVC.view];
    
//    tableVC.view.frame = CGRectMake(0, 0, 320, 400);
    
    tableVC.view.backgroundColor = [UIColor purpleColor];
    
    self.view.backgroundColor = [UIColor brownColor];

    NSLog(@" self.view %f %f",self.view.bounds.size.height,self.view.frame.size.height);

    NSLog(@" tableVC.view %f %f",tableVC.view.bounds.size.height,tableVC.view.frame.size.height);
}

- (void)navInit {

    self.title = @"MutiTableViewDemo";

    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightItem;

    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick:)];
    leftItem.tintColor = [UIColor redColor];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)rightClick:(UIBarButtonItem *)sender {
    [tableVC rightClick:sender];
}
- (void)deleteClick:(UIBarButtonItem *)sender {
    [tableVC deleteClick:sender];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
