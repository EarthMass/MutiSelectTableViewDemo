//
//  CustomCell.m
//  MutiSelectTableViewDemo
//
//  Created by Guohx on 16/6/2.
//  Copyright © 2016年 guohx. All rights reserved.
//

#import "CustomCell.h"

@interface CustomCell()

@property (weak, nonatomic) IBOutlet UILabel *desLab;


@end

@implementation CustomCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setInfo:(NSIndexPath *)indexpath num:(NSString *)num  {
    
    _desLab.text = [NSString stringWithFormat:@"%@{%ld,%ld}",num,(long)indexpath.section,(long)indexpath.row];
    
    //    [self setCellSelect:NO];
}

- (void)setCellSelect:(BOOL)select {
//    self.backgroundColor = (select)?[UIColor colorWithRed:0.673 green:0.336 blue:0.003 alpha:1.000]:[UIColor lightGrayColor];
    self.backgroundColor = [UIColor lightGrayColor];
    
    
}
- (void)setCellDisSelect:(BOOL)disselect {
    self.alpha = (disselect)?0.7:1;
    self.userInteractionEnabled = !disselect; 
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setCellSelect:selected];
}

- (void)clearAllStatus:(BOOL)disselect {
    self.userInteractionEnabled = YES;
}


@end
