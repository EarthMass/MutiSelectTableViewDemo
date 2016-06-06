//
//  MutiTableViewVC.m
//  MutiSelectTableViewDemo
//
//  Created by Guohx on 16/6/2.
//  Copyright © 2016年 guohx. All rights reserved.
//

#import "MutiTableViewVC.h"
#import "CustomCell.h"
#import "User.h"
#import "BottomView.h"

#define KEY @"objectId" ///<查询、过滤关键字

static float bottomV_H = 40.0f; ///<底部选择栏高度

@interface MutiTableViewVC () <UITableViewDelegate, UITableViewDataSource> {
    BottomView * bottomV;
    BOOL editTableV; ///<是否编辑tableV
}
@property (nonatomic, strong) UITableView * tableView;

@end

@implementation MutiTableViewVC

- (void)initData {
    
    self.selectArr = [[NSMutableSet alloc] init];
    self.disSelectArr = [[NSMutableSet alloc] init];
    
    self.dataArr = [NSMutableArray array];
    
    for (int i =0; i < 6; i ++) {
        User * user = [[User alloc] init];
        user.objectId = [NSString stringWithFormat:@"%d",i];
        user.objectName = [NSString stringWithFormat:@" %d",i];
        [_dataArr addObject:user];
    }
    
    for (int i =0; i < 3; i ++) {
        if (i == 0 || i == 2 ) {
            User * user = [[User alloc] init];
            user.objectId = [NSString stringWithFormat:@"%d",i];
            user.objectName = [NSString stringWithFormat:@" %d",i];
            [_disSelectArr addObject:user];
        }
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"viewDidLoad tableView VV %f %f",self.view.bounds.size.height,self.view.frame.size.height);
//    [self navInit];
    
    CGRect viewFrame = self.view.frame;
    viewFrame.size.height =  viewFrame.size.height;
    self.view.frame = viewFrame;
    
    [self initData];
    
    [self initUI];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
//    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0) {
    
    self.tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, (editTableV)?(self.view.frame.size.height - bottomV_H):self.view.frame.size.height);
//    }

    //iOS7必须执行
    [self.view layoutSubviews];
}

- (void)initUI {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
    
    NSLog(@" tableView VV %f %f",self.view.bounds.size.height,self.view.frame.size.height);
    
     NSLog(@" tableView %f %f",self.tableView.bounds.size.height,self.tableView.frame.size.height);
    
}

//- (void)navInit {
//    
//    self.title = @"MutiTableViewDemo";
//    
//    self.edgesForExtendedLayout = UIRectEdgeNone;
//    
//    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
//    self.navigationItem.rightBarButtonItem = rightItem;
//    
//    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick:)];
//    leftItem.tintColor = [UIColor redColor];
//    self.navigationItem.leftBarButtonItem = leftItem;
//}

//#ifdef __IPHONE_7_0
//- (UIRectEdge)edgesForExtendedLayout {
//    return UIRectEdgeNone;
//}
//#endif

//获取父控制器
- (UIViewController*)viewController {
    for (UIView* next = [self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}

#pragma mark- 导航栏按钮点击

- (void)rightClick:(UIBarButtonItem *)sender {
    
    UIViewController * baseVC = ([self viewController])?[self viewController]:self;
    
    if ([sender.title isEqualToString:@"编辑"]) {
        sender.title = @"取消";

        editTableV = YES;
        
        baseVC.navigationItem.leftBarButtonItem.title = @"删除";

        [self setTableViewMutiSelect:YES];
        [self bottomViewShow:YES];
        
    } else {
        sender.title = @"编辑";
        
        editTableV = NO;
        
        baseVC.navigationItem.leftBarButtonItem.title = @"";
        [self setTableViewMutiSelect:NO];
        [self bottomViewShow:NO];
        
    }
     NSLog(@" tableView VV %f %f",self.view.bounds.size.height,self.view.frame.size.height);
    [self refreshData];
}

- (void)deleteClick:(UIBarButtonItem *)sender {
    
    NSArray * arr = [[_selectArr valueForKeyPath:KEY] allObjects];
    
    //排序
    NSArray * sortDesc = @[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]];
    NSArray * sortArr  = [arr sortedArrayUsingDescriptors:sortDesc];
    NSString * str = [sortArr componentsJoinedByString:@"，"];
    
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"删除 :%@",str] delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)setTableViewMutiSelect:(BOOL)muti {
    self.tableView.allowsMultipleSelectionDuringEditing = muti;
    self.tableView.editing = muti;
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifierAbout = @"CustomCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        //第一次硬盘加载Nib，在内存中缓存Nib，之后从内存拷贝Nib，避免较慢的硬盘访问，提高效率
        UINib * nib = [UINib nibWithNibName:@"CustomCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifierAbout];
        nibsRegistered = YES;
    }
    //自定义cell类
    CustomCell * cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifierAbout];
    
    User * user = _dataArr[indexPath.row];
    [cell setInfo:indexPath num:user.objectName];
    
    //选中颜色
    cell.selectedBackgroundView = ({
        UIView * selectView = [[UIView alloc] initWithFrame:cell.bounds];
        selectView.backgroundColor = (self.tableView.allowsSelectionDuringEditing)?[UIColor clearColor]:[UIColor brownColor];
        selectView;
    });
    

    
    return cell;
}


#pragma mark - Table view delegate
#pragma mark- 多选 全选
//是否缩进
- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    return [self isCanSelect:indexPath];
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView 点击了 %ld %ld",(long)indexPath.section,(long)indexPath.row);
    
    [self addSelect:indexPath];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView 取消了 %ld %ld",(long)indexPath.section,(long)indexPath.row);

    [self deSelect:indexPath];
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
////    return YES;
//}
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return UITableViewCellEditingStyleDelete;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0f;
}

#pragma mark 操作逻辑

/**
 *  多选操作时 查询不能选中的索引数组 在cellForItemAtIndexPath 处理
 *
 *  @return 不能选中的索引数组
 */
- (void)updataDisableSelCell:(CustomCell *)cell
                   indexPath:(NSIndexPath *)indexPath {
    if (!([_disSelectArr count] && self.tableView.allowsSelectionDuringEditing)) {
        
        [cell setCellSelect:NO];
        return;
    }
    //不可选的
    NSArray * disSelIdArr = [_disSelectArr valueForKey:KEY];
    NSArray * dataIdArr = [_dataArr valueForKey:KEY];
    NSMutableArray * disSelIndexArr = [NSMutableArray array];
    
    for (NSString * idStr in disSelIdArr) {
        if ([dataIdArr containsObject:idStr]) {
            NSInteger index = [dataIdArr indexOfObject:idStr];
            [disSelIndexArr addObject:@(index)];
        }
    }
    
    if ([disSelIndexArr containsObject:@(indexPath.row)]) {
        [cell setCellDisSelect:YES];
    } else {
        [cell setCellSelect:NO];
    }
}

/**
 *  多选操作时 选中的 在cellForItemAtIndexPath 处理
 *
 *  @return 选中的索引数组
 */
- (void)updataSelCell:(CustomCell *)cell
            indexPath:(NSIndexPath *)indexPath {
    if (!([_disSelectArr count] && self.tableView.allowsSelectionDuringEditing)) {
        
        [cell setCellSelect:NO];
        
        return;
    }
    //选中的
    NSArray * selIdArr = [_selectArr valueForKey:KEY];
    NSArray * dataIdArr = [_dataArr valueForKey:KEY];
    NSMutableArray * selIndexArr = [NSMutableArray array];
    
    for (NSString * idStr in selIdArr) {
        if ([dataIdArr containsObject:idStr]) {
            NSInteger index = [dataIdArr indexOfObject:idStr];
            [selIndexArr addObject:@(index)];
        }
    }
    
    if ([selIndexArr containsObject:@(indexPath.row)]) {
        [cell setCellSelect:YES];
    } else {
        [cell setCellSelect:NO];
    }
}

- (void)clearAllStatus:(CustomCell *)cell
             indexPath:(NSIndexPath *)indexPath {
    if (!([_disSelectArr count] && self.tableView.allowsSelectionDuringEditing)) {
        
        [cell clearAllStatus:YES];
        return;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self clearAllStatus:(CustomCell *)cell indexPath:indexPath];
    [self updataDisableSelCell:(CustomCell *)cell indexPath:indexPath];
    [self updataSelCell:(CustomCell *)cell indexPath:indexPath];

}

#pragma mark 底部操作
- (void)bottomViewShow:(BOOL)show {

    if (show) {
        
        if (![self.view viewWithTag:8888]) {
            bottomV = [[[NSBundle mainBundle] loadNibNamed:@"BottomView" owner:self options:nil] lastObject];
            bottomV.tag = 8888;
            bottomV.frame = CGRectMake(0, self.view.frame.size.height - bottomV_H, self.view.frame.size.width, bottomV_H);
            
            __block typeof(self) weakSelf = self;
            [bottomV allSelClick:^(BOOL isSelect) {
                if (!isSelect) {
                    //全选
                    [weakSelf allSelect];
                } else {
                    //全不选
                    [weakSelf allDeselect];
                }
            } deleteSelBlock:^{
                //删除操作
                [weakSelf deleteSelect];
            }];
            
            [self.view addSubview:bottomV];
        }
        [self.view bringSubviewToFront:bottomV];
    } else {
        if ([self.view viewWithTag:8888]) {
            [[self.view viewWithTag:8888] removeFromSuperview];
        }
    }
    
}

- (void)updateBottomView {
    if (bottomV && self.tableView.allowsMultipleSelectionDuringEditing) {
        BOOL isAll = [self isAllSelect];
        bottomV.allSelBtn.selected =  isAll;
    }
}

//- (void)updateCellView:(UICollectionViewCell *)cell {
//    cell
//}

/**
 *  判断是否全选了【可选的】
 *
 *  @return YES/NO
 */
- (BOOL)isAllSelect {
    
    return [_selectArr isEqualToSet:[self canSelArr]];
}

- (NSSet *)canSelArr {
    
    NSArray * deselectIdArr = [_disSelectArr valueForKeyPath:KEY];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"NOT(%K in %@)",KEY,deselectIdArr];
    NSArray * tmpArr = [_dataArr filteredArrayUsingPredicate:predicate];
    
    NSSet * tmpSet = [[NSSet alloc] initWithArray:tmpArr];
    
    return tmpSet;
}

- (BOOL)isCanSelect:(NSIndexPath *)indexPath {
    
    if (![_disSelectArr count]) {
        return YES;
    }
    
    if (self.tableView.allowsSelectionDuringEditing) {
        User * contact = _dataArr[indexPath.row];
        NSArray * disSelectIdArr = [_disSelectArr valueForKey:KEY];
        if ([disSelectIdArr containsObject:contact.objectId]) {
            return NO;
        } else {
            return YES;
        }
    }
    return YES;
}

- (void)addSelect:(NSIndexPath *)indexPath {
    if ([self isCanSelect:indexPath]) {
        [_selectArr addObject:_dataArr[indexPath.row]];
        
        [self updateBottomView];
    }
    
}

- (void)deSelect:(NSIndexPath *)indexPath {
    if ([self isCanSelect:indexPath]) {
        [_selectArr removeObject:_dataArr[indexPath.row]];
        
        [self updateBottomView];
        
    }
}

#pragma mark 全选 全不选操作 删除
//全选
- (void)allSelect {
    [_selectArr removeAllObjects];
    
    NSArray * indexArr = [self getIndexArr:_dataArr targetSet:[self canSelArr]];
    __block typeof(self) weakSelf = self;
    [indexArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * indexPath = obj;
        
        [weakSelf.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }];
        [_selectArr setSet:[self canSelArr]];
    
}
//全不选
- (void)allDeselect {
    
    NSArray * indexArr = [self getIndexArr:_dataArr targetSet:_selectArr];
    __block typeof(self) weakSelf = self;
    [indexArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath * indexPath = obj;
        [weakSelf.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }];
    [_selectArr removeAllObjects];
}
//删除
- (void)deleteSelect {
    NSArray * selIdArr = [_selectArr valueForKey:KEY];
    NSArray * dataIdArr = [_dataArr valueForKey:KEY];
    
    //比对 获取 选中项的 索引 , 用于删除选中的cell
    __block NSMutableArray * selIndexPathArr = [NSMutableArray array];
    __block NSMutableIndexSet * selIndexArr = [NSMutableIndexSet indexSet];
    [selIdArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString * str = [NSString stringWithFormat:@"%@",obj];
        
        if ([dataIdArr indexOfObject:str] < MAXFLOAT) {
            
            [selIndexPathArr addObject:[NSIndexPath indexPathForRow:[dataIdArr indexOfObject:str] inSection:0]];
            [selIndexArr addIndex:[dataIdArr indexOfObject:str]];
        }
        
    }];
    
    //删除cell 移除dataArr数据
    //    [collectionV deleteItemsAtIndexPaths:selIndexPathArr];
    
    [_dataArr removeObjectsAtIndexes:selIndexArr];
    [self refreshData];
    [self.tableView reloadData];
}

//刷新数据 选中项 不可编辑项 【单一次处理完成后】
- (void)refreshData {
    [_selectArr removeAllObjects];
}

//判断cell选中状态
- (BOOL)checkCellIsSel:(NSIndexPath *)indexPath {
    
    NSArray * selIdArr = [_selectArr valueForKey:KEY];
    User * user = _dataArr[indexPath.row];
    
    BOOL isSel = [selIdArr containsObject:user.objectId];
    
    return isSel;
}

/**
 *  获取数组在 源数组 中的 索引
 *
 *  @param data      源数组
 *  @param targetSet 目标数组
 *
 *  @return 索引数组 [NSIndexPath]
 */
- (NSArray *)getIndexArr:(NSArray *)data targetSet:(NSSet *)targetSet {
    
    NSArray * targetIdArr = [targetSet valueForKey:KEY];
    NSArray * dataIdArr = [data valueForKey:KEY];
    NSMutableArray * indexArr = [NSMutableArray array];
    
    for (NSString * idStr in targetIdArr) {
        if ([dataIdArr containsObject:idStr]) {
            NSInteger index = [dataIdArr indexOfObject:idStr];
            [indexArr addObject:[NSIndexPath indexPathForItem:index inSection:0]];
        }
    }
    return indexArr;
    
}



/*

*/

@end
