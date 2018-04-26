//
//  YSFileVC.m
//  YSUtils
//
//  Created by 杨森 on 2018/4/25.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "YSFileVC.h"
#import "YSFile.h"
#import "YSFileItemCell.h"
#import "YSPreviewController.h"

@interface YSFilePreviewVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic ,strong, nonnull)YSFileItem  *fileItem;
@property (nonatomic ,strong, nonnull)UITableView *tableView;

+ (instancetype)filePreviewVCWithFilePath:(NSString *)filePath;

@end

@implementation YSFilePreviewVC

+ (instancetype)filePreviewVCWithFilePath:(NSString *)filePath{
    YSFilePreviewVC *filePreview = [[YSFilePreviewVC alloc] init];
    filePreview.fileItem = [YSFile itemAtPath:filePath];
    return filePreview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.title = self.fileItem.name;
    self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    self.tableView.delegate   = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorColor  = [UIColor clearColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"YSFileItemCell" bundle:nil] forCellReuseIdentifier:@"YSFileItemCell"];
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAction)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

//MARK:创建
- (void)addAction{
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"创建类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *fileAction = [UIAlertAction actionWithTitle:@"文件夹" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertUserSetFileItemNameIsDire:YES];
    }];
    UIAlertAction *direAction = [UIAlertAction actionWithTitle:@"文件" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self alertUserSetFileItemNameIsDire:NO];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:fileAction];
    [alertC addAction:direAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)alertUserSetFileItemNameIsDire:(BOOL)isDire{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *itemNameTF = nil;
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        itemNameTF = textField;
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self addFileItemWithName:itemNameTF.text isDire:isDire];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)addFileItemWithName:(NSString *)name isDire:(BOOL)isDire{
    if (!name.length) {
        return;
    }
    NSString *path = [self.fileItem.path stringByAppendingFormat:@"/%@",name];
    BOOL success = [YSFile createItemAtPath:path isDirectory:isDire];
    if (success) {
        [self reflushUI];
    }
}

//MARK:重命名
- (void)alertUserRenameFileItemName:(YSFileItem *)fileItem{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *itemNameTF = nil;
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        itemNameTF = textField;
    }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self renameFileItemWithName:itemNameTF.text fileItem:fileItem];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:sureAction];
    [alertC addAction:cancelAction];
    [self presentViewController:alertC animated:YES completion:nil];
}

- (void)renameFileItemWithName:(NSString *)name fileItem:(YSFileItem *)fileItem{
    if (!name.length) {
        return;
    }
    NSString *oldPath = fileItem.path;
    NSString *newPath = [self.fileItem.path stringByAppendingFormat:@"/%@",name];
    BOOL success = [YSFile modifyItemAtPath:oldPath newPath:newPath];
    if (success) {
        [self reflushUI];
    }
}

- (void)reflushUI{
    self.fileItem = [YSFile itemAtPath:self.fileItem.path];
    [self.tableView reloadData];
}

//MARK: tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _fileItem.subFileItems.count + _fileItem.subDirectoryItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    YSFileItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YSFileItemCell" forIndexPath:indexPath];
    if (indexPath.row%2) {
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }else{
        cell.contentView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    }
    cell.fileItem = [self fileItemAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    YSFileItem *item = [self fileItemAtIndex:indexPath.row];
    if (item.isDirectory) {
        YSFilePreviewVC *filePreviewVC = [YSFilePreviewVC filePreviewVCWithFilePath:item.path];
        [self.navigationController pushViewController:filePreviewVC animated:YES];
    }else{
        YSPreviewController *preview = [YSPreviewController previewControllerWithPath:item.path];
        [self.navigationController pushViewController:preview animated:YES];
    }
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        YSFileItem *fileItem = [self fileItemAtIndex:indexPath.row];
        BOOL isSuccess = [YSFile deleteItemAtPath:fileItem.path];
        if (isSuccess) {
            [self reflushUI];
        }
    }];
    UITableViewRowAction *renameAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"重命名" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        [self alertUserRenameFileItemName:[self fileItemAtIndex:indexPath.row]];
    }];
    return @[deleteAction, renameAction];
}

- (YSFileItem *)fileItemAtIndex:(NSInteger)index{
    YSFileItem *fileItem = nil;
    if (index < self.fileItem.subDirectoryItems.count) {
        fileItem = self.fileItem.subDirectoryItems[index];
    }else{
        index -= self.fileItem.subDirectoryItems.count;
        fileItem = self.fileItem.subFileItems[index];
    }
    return fileItem;
}

@end

@interface YSFileVC ()
@end

@implementation YSFileVC

+ (instancetype)filePreviewVCWithFilePath:(NSString *)filePath{
    YSFilePreviewVC *filePreviewVC = [YSFilePreviewVC filePreviewVCWithFilePath:filePath];
    YSFileVC *fileVC = [[YSFileVC alloc] initWithRootViewController:filePreviewVC];
    return fileVC;
}

@end
