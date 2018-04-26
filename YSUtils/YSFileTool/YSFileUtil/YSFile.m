//
//  YSFile.m
//  YSUtils
//
//  Created by 杨森 on 2018/4/25.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "YSFile.h"
static NSString *kHomeName = nil;
@implementation YSFileItem
+(void)load{
    [super load];
    NSString *homePath = NSHomeDirectory();
    kHomeName = [homePath componentsSeparatedByString:@"/"].lastObject;
}
- (void)setName:(NSString *)name{
    if ([name isEqualToString:kHomeName]) {
        _name = @"Home";
    }else{
        _name = [name copy];
    }
}
@end
@implementation YSFile

/** 根据路径 查询 文件信息 */
+ (YSFileItem *_Nullable)itemAtPath:(NSString *_Nullable)path{
    YSFileItem *item = [[YSFileItem alloc] init];
    item.path = path;
    item.name = [path componentsSeparatedByString:@"/"].lastObject;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    NSDictionary *itemAttr = [fileMgr attributesOfItemAtPath:path error:nil];
    item.modifyDate = [itemAttr fileModificationDate];
    item.isDirectory= [[itemAttr fileType] isEqualToString:NSFileTypeDirectory];
    
    NSMutableArray *files = [[NSMutableArray alloc] init];
    NSMutableArray *dirs  = [[NSMutableArray alloc] init];
    NSArray *filenames    = [fileMgr contentsOfDirectoryAtPath:path error:nil];
    for (NSString *filename in filenames) {
        YSFileItem *item_P   = [[YSFileItem alloc] init];
        NSString *item_PPath = [NSString stringWithFormat:@"%@/%@", path, filename];
        NSDictionary *fileAttr = [fileMgr attributesOfItemAtPath:item_PPath error:nil];
        item_P.path = item_PPath;
        item_P.name = filename;
        item_P.size = [fileAttr fileSize];
        item_P.modifyDate = [fileAttr fileModificationDate];
        if ([[fileAttr fileType] isEqualToString:NSFileTypeDirectory]) {
            item_P.isDirectory = YES;
        }
        if (item_P.isDirectory) {
            [dirs addObject:item_P];
        } else {
            [files addObject:item_P];
        }
    }
    item.subFileItems      = [files copy];
    item.subDirectoryItems = [dirs copy];
    return item;
}

/** 创建路径 或者 文件 */
+ (BOOL)createItemAtPath:(NSString *_Nullable)path isDirectory:(BOOL)isDirectory{
    BOOL success           = NO;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isExist           = isExist = [fileMgr fileExistsAtPath:path isDirectory:nil];
    if (isExist) {
        NSLog(@"资源已存在");
    }else{
        if (isDirectory) {
            success = [fileMgr createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }else{
            success = [fileMgr createFileAtPath:path contents:nil attributes:nil];
        }
    }
    return success;
}
/** 修改路径 或者 文件 */
+ (BOOL)modifyItemAtPath:(NSString *_Nullable)path newPath:(NSString * _Nullable)newPath{
    BOOL success           = NO;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isOldExist        = [fileMgr fileExistsAtPath:path isDirectory:nil];
    if (isOldExist) {
        NSError *error = nil;
        success = [fileMgr moveItemAtPath:path toPath:newPath error:&error];
    }else{
        NSLog(@"修改前路径 或 修改后的路径不存在");
    }
    return success;
}
/** 删除路径 或者 文件 */
+ (BOOL)deleteItemAtPath:(NSString *)path{
    BOOL success           = NO;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL isExist           = [fileMgr fileExistsAtPath:path isDirectory:nil];
    if (isExist) {
        success = [fileMgr removeItemAtPath:path error:nil];
    }else{
        NSLog(@"资源不存在");
    }
    return success;
}

@end
