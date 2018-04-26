//
//  ViewController.m
//  YSUtils
//
//  Created by 杨森 on 2018/4/25.
//  Copyright © 2018年 yangsen. All rights reserved.
//

#import "ViewController.h"
#import "YSFileVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    YSFileVC *fileVC = [YSFileVC filePreviewVCWithFilePath:NSHomeDirectory()];
    [self presentViewController:fileVC animated:YES completion:nil];
}

@end
