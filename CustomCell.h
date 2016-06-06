//
//  CustomCell.h
//  MutiSelectTableViewDemo
//
//  Created by Guohx on 16/6/2.
//  Copyright © 2016年 guohx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell

- (void)setInfo:(NSIndexPath *)indexpath num:(NSString *)num;

- (void)setCellSelect:(BOOL)select;
- (void)setCellDisSelect:(BOOL)disselect;

- (void)clearAllStatus:(BOOL)disselect;

@end
