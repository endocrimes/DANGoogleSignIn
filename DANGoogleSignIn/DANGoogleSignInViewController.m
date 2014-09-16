//
//  DANGoogleSignInViewController.m
//  DANGoogleSignIn
//
//  Created by  Danielle Lancashireon 02/09/2014.
//  Copyright (c) 2014 Rocket Apps. All rights reserved.
//

#import "DANGoogleSignInViewController.h"
#import "DANGoogleSignInWebView.h"

NSString * const DANGoogleSignInViewControllerAuthorizationTokenEndpoint = @"https://accounts.google.com/o/oauth2/auth";
NSString * const DANGoogleSignInViewControllerRedirectUri = @"urn:ietf:wg:oauth:2.0:oob";

@interface UIView (DANGSIWVCenterInSuperview)
- (void)DANGSIWV_centerInSuperview;
@end

@implementation UIView (DANGSIWVCenterInSuperview)

- (void)DANGSIWV_centerInSuperview {
  NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[self]-0-|"
                                                                options:NSLayoutFormatDirectionLeadingToTrailing
                                                                metrics:nil
                                                                  views:NSDictionaryOfVariableBindings(self)];

  NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[self]-0-|"
                                                              options:NSLayoutFormatDirectionLeadingToTrailing
                                                              metrics:nil
                                                                views:NSDictionaryOfVariableBindings(self)];

  [self.superview addConstraints:horizontal];
  [self.superview addConstraints:vertical];
}

@end

@interface NSString (DANGSIWVStringAdditions)

- (NSString *)DANSIWV_urlEncodedString;

@end

@implementation NSString (DANGSIWVStringAdditions)

- (NSString *)DANSIWV_urlEncodedString {
  NSMutableString *output = [NSMutableString string];
  const unsigned char *source = (const unsigned char *)[self UTF8String];
  unsigned long sourceLen = strlen((const char *)source);
  for (int i = 0; i < sourceLen; ++i) {
    const unsigned char thisChar = source[i];
    if (thisChar == ' '){
      [output appendString:@"+"];
    } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
               (thisChar >= 'a' && thisChar <= 'z') ||
               (thisChar >= 'A' && thisChar <= 'Z') ||
               (thisChar >= '0' && thisChar <= '9')) {
      [output appendFormat:@"%c", thisChar];
    } else {
      [output appendFormat:@"%%%02X", thisChar];
    }
  }
  return [output copy];
}

@end

@interface DANGoogleSignInViewController () <UIWebViewDelegate>
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSArray *scopes;
@property (nonatomic, weak) DANGoogleSignInWebView *webView;
@end

@implementation DANGoogleSignInViewController

#pragma mark - Designated Initializer

- (instancetype)initWithClientId:(NSString *)clientId
                          scopes:(NSArray *)scopes {
  self = [super init];

  if (self) {
    _clientId = clientId;
    _scopes = scopes;
  }

  return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  [super viewDidLoad];

  DANGoogleSignInWebView *webView = [[DANGoogleSignInWebView alloc] init];
  webView.delegate = self;
  webView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.view addSubview:webView];
  [webView DANGSIWV_centerInSuperview];
  self.webView = webView;

  NSString *scopes = [self urlEncodeAndConcatenateArray:self.scopes];
  // Form the URL string.
  NSString *targetURLString = [NSString stringWithFormat:@"%@?scope=%@&redirect_uri=%@&client_id=%@&response_type=code",
                               DANGoogleSignInViewControllerAuthorizationTokenEndpoint,
                               scopes,
                               DANGoogleSignInViewControllerRedirectUri,
                               self.clientId];

  // Make the request and add self (webview) to the parent view.
  [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:targetURLString]]];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  UIWebView *webView = _webView;
  /*
   The tales of UIWebView memory leaks are spread far and wide, with many a dev
   debating how to properly scrub your memory of it's terrors and to properly
   deallocate it from this world, I've lovingly (read: unfortunately) had to
   write this method.

   The first tale that has spread far and wide has said that the great UIWebView
   does not correctly throw away is junk views and objects without first loading
   empty content.
   */
  [webView loadHTMLString:@"" baseURL:nil];

  /*
   Some claim that the great UIWebView will spring a leak if content is loading
   during deallocation.
   */
  [webView stopLoading];

  /*
   The third be fact and comes from our overlords themselves and goes like so:
   "Important: Before releasing an instance of UIWebView for which you have set
   a delegate, you must first set the UIWebView delegate property to nil before
   disposing of the UIWebView instance. This can be done, for example, in the
   dealloc method where you dispose of the UIWebView."
   */
  webView.delegate = nil;

  /*
   And the final rule be that if you're creating multiple child views for any
   given view, and you're trying to deallocate an old child, that child is
   pointed to by the parent view, and won't actually deallocate until that
   parent view dissapears. This ensures that you are not creating many child
   views that will hang around until the parent view is deallocated.
   */
  [webView removeFromSuperview];

  webView = nil;
}

- (void)dealloc {
  _webView = nil;
  _scopes = nil;
  _clientId = nil;
  _successBlock = nil;
  _failureBlock = nil;
}

#pragma mark - Helpers

- (NSString *)urlEncodeAndConcatenateArray:(NSArray *)anArray {
  [anArray valueForKey:NSStringFromSelector(@selector(DANSIWV_urlEncodedString))];

  return [anArray componentsJoinedByString:@"+"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  //source: http://blog.techno-barje.fr/post/2010/10/04/UIWebView-secrets-part1-memory-leaks-on-xmlhttprequest/
  [[NSUserDefaults standardUserDefaults] setInteger:0
                                             forKey:@"WebKitCacheModelPreferenceKey"];

  // Get the web pages title
  NSString *webViewTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

  // Check for the success literal
  if ([webViewTitle rangeOfString:@"Success"].location != NSNotFound) {
    // The authorization code has been retrieved, Break the title based upon `=`
    NSArray *titleParts = [webViewTitle componentsSeparatedByString:@"="];

    // The last part should be the authorization code
    NSString *authorizationCode = titleParts.lastObject;

    if (self.successBlock) {
      self.successBlock(authorizationCode);
    }
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
  if (self.failureBlock) {
    self.failureBlock(error, error.localizedDescription);
  }
}

@end
