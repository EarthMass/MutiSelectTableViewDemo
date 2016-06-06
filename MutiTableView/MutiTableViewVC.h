//
//  MutiTableViewVC.h
//  MutiSelectTableViewDemo
//
//  Created by Guohx on 16/6/2.
//  Copyright © 2016年 guohx. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  多选tableViewViewController 控制器 [不能继承UITableViewController，self.view=self.tableView添加的视图会随滚动]
 */
@interface MutiTableViewVC : UIViewController 
    
@property (nonatomic, strong) NSMutableSet * selectArr; ///<可选的
@property (nonatomic, strong) NSMutableSet * disSelectArr; ///<不可选的

@property (nonatomic, strong) NSMutableArray * dataArr; ///<数据数组


- (void)rightClick:(UIBarButtonItem *)sender;
- (void)deleteClick:(UIBarButtonItem *)sender;

@end
