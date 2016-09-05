//
//  HCWebViewController.m
//  WebViewProgressDemo
//
//  Created by Jentle on 16/9/5.
//  Copyright © 2016年 Jentle. All rights reserved.
//

#import "HCWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

@interface HCWebViewController ()<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property(strong, nonatomic) NJKWebViewProgressView *progressView;
@property(strong, nonatomic) NJKWebViewProgress *progressProxy;
@property(weak, nonatomic) UIWebView *webView;

@end

@implementation HCWebViewController

/**
 *  添加进度条
 */
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}
/**
 *  移除进度条
 */
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initComponents];
    [self initProgressBar];
    [self loadBaidu];
}

- (void)initComponents{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshAction)];
}
- (void)searchAction{
    [self loadBaidu];
}

- (void)refreshAction{
    [self.webView reload];
}

/**
 *  初始化进度条
 */
- (void)initProgressBar{
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:webView];
    webView.delegate = _progressProxy;
    _webView = webView;
    
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
   _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
}

- (void)loadBaidu{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [_webView loadRequest:req];
}

#pragma mark - <NJKWebViewProgressDelegate>

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    self.title = [_webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

@end
