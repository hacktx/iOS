//
//  ProfileViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "ProfileViewController.h"
#import "MBProgressHUD.h"
#import "HTXConstants.h"

@import WebKit;

@interface ProfileViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *MLHAuthURL = [NSURL URLWithString:[NSString stringWithFormat:kMLHAuthURL, kMLHClientId, kMLHAuthRedirect]];
    NSURLRequest *MLHAuthRequest = [NSURLRequest requestWithURL:MLHAuthURL];
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    self.webView.navigationDelegate = self;
    [self.webView loadRequest:MLHAuthRequest];
    self.webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:self.webView];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKWebView Delegates

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)webView:(WKWebView *)webView
decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction
decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString *newURL = navigationAction.request.URL.absoluteString;
    if ([newURL hasPrefix:kMLHAuthRedirect]) {
        NSLog(@"Auth completed!");
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
