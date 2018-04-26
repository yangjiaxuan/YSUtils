//
//  YSFileItemCell.m
//  YSUtils
//
//  Created by 杨森 on 2018/4/25.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "YSFileItemCell.h"

@interface YSFileItemCell()

@property (strong, nonatomic) IBOutlet UIImageView *hdImageV;
@property (strong, nonatomic) IBOutlet UILabel *nameL;
@property (strong, nonatomic) IBOutlet UILabel *dateL;

@end
@implementation YSFileItemCell

- (void)setFileItem:(YSFileItem *)fileItem{
    _fileItem = fileItem;
    if (fileItem.isDirectory) {
        _hdImageV.image = [UIImage imageNamed:@"directory"];
    }else{
        _hdImageV.image = [UIImage imageNamed:@"other"];
    }
    _nameL.text = fileItem.name;
    _dateL.text = @"2018-10-10 12:12:30";
}

@end
