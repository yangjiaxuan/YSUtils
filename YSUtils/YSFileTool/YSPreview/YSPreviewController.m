//
//  YSPreviewController.m
//  FrameDemo
//
//  Created by yangsen on 17/4/13.
//  Copyright © 2017年 sitemap. All rights reserved.
//

#import "YSPreviewController.h"

#import <WebKit/WebKit.h>

@interface YSPreviewController ()<WKNavigationDelegate>
{
    UIActivityIndicatorView *_activityIV;
    WKWebView *_webView;
}
@property (nonatomic ,strong, nonnull)NSURL *resourcePath;

@end

@implementation YSPreviewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.resourcePath) {

        WKPreferences *preferences  = [[WKPreferences alloc] init];
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        preferences.minimumFontSize = 40.0;
        
        WKUserContentController *userContentC      = [[WKUserContentController alloc]init];
        
        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc]init];
        webViewConfiguration.userContentController = userContentC;
        webViewConfiguration.preferences           = preferences;
        _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds configuration:webViewConfiguration];
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:self.resourcePath];
        [_webView loadRequest:request];
        
        _activityIV = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIV.frame  = CGRectMake(0, 0, 40, 40);
        _activityIV.center = self.view.center;
        [self.view addSubview:_activityIV];
        [_activityIV startAnimating];
    }
}

+ (id)previewControllerWithPath:(NSString *)path{
    YSPreviewController *preview = [[YSPreviewController alloc] init];
    if (path.length) {
        preview.resourcePath = [NSURL fileURLWithPath:path];
    }
    return preview;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webView stopLoading];
}

#pragma mark 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"====== 开始 ======");
}

#pragma mark 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation{
    NSLog(@"成功");
//    NSInteger screenW = [UIScreen mainScreen].bounds.size.width;
//    [_webView evaluateJavaScript:[NSString stringWithFormat:@"document.body.style.font='80px';document.body.clientWidth='%zdpx';document.body.scrollWidth='%zdpx';",screenW,screenW] completionHandler:^(id _Nullable info, NSError * _Nullable error) {
//
//    }];
//    [_webView evaluateJavaScript:@"document.write('<style>body{font-size:20px;width:414px;}</style>');" completionHandler:^(id _Nullable info, NSError * _Nullable error) {
//
//    }];
    [_activityIV stopAnimating];
}

#pragma mark 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [_activityIV stopAnimating];
}


#pragma mark WKNavigation导航错误
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    [_activityIV stopAnimating];
}

#pragma mark WKWebView终止
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [_activityIV stopAnimating];
}


@end
