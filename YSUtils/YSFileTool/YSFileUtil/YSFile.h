//
//  YSFile.h
//  YSUtils
//
//  Created by 杨森 on 2018/4/25.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSFileItem : NSObject

/** 是否为文件夹 */
@property (nonatomic ,assign)BOOL isDirectory;
/** 路径 */
@property (nonatomic ,  copy, nullable)NSString *path;
/** 名字 */
@property (nonatomic ,  copy, nullable)NSString *name;
/** 大小 */
@property (nonatomic ,assign)unsigned long long size;
/** 修改日期 */
@property (nonatomic, strong, nullable) NSDate *modifyDate;
/** 子项目文件 */
@property (nonatomic ,strong, nullable)NSArray <YSFileItem *> *subFileItems;
/** 子项目文件夹 */
@property (nonatomic ,strong, nullable)NSArray <YSFileItem *> *subDirectoryItems;

@end

@interface YSFile : NSObject

/** 根据路径 查询 文件信息 */
+ (YSFileItem *_Nullable)itemAtPath:(NSString *_Nullable)path;
/** 创建路径 或者 文件 */
+ (BOOL)createItemAtPath:(NSString *_Nullable)path isDirectory:(BOOL)isDirectory;
/** 修改路径 或者 文件 */
+ (BOOL)modifyItemAtPath:(NSString *_Nullable)path newPath:(NSString *_Nullable)newPath;
/** 删除路径 或者 文件 */
+ (BOOL)deleteItemAtPath:(NSString *_Nullable)path;


@end
