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
  // Leading
  NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.superview
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1
                                                              constant:0];
  NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self
                                                              attribute:NSLayoutAttributeTrailing
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.superview
                                                              attribute:NSLayoutAttributeTrailing
                                                             multiplier:1
                                                               constant:0];
  NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self.superview
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1
                                                          constant:0];
  NSLayoutConstraint *bottom = [NSLayoutConstraint constraintWithItem:self
                                                            attribute:NSLayoutAttributeBottom
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.superview
                                                            attribute:NSLayoutAttributeBottom
                                                           multiplier:1
                                                             constant:0];

  [self addConstraints:@[leading, trailing, top, bottom]];
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

#pragma mark - Helpers

- (NSString *)urlEncodeAndConcatenateArray:(NSArray *)anArray {
  [anArray valueForKey:NSStringFromSelector(@selector(DANSIWV_urlEncodedString))];

  return [anArray componentsJoinedByString:@"+"];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  // Get the web pages title
  NSString *webViewTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

  // Check for the success literal
  if ([webViewTitle rangeOfString:@"Success"].location != NSNotFound) {
    // The authorization code has been retriefed, Break the title based upon `=`
    NSArray *titleParts = [webViewTitle componentsSeparatedByString:@"="];

    // The last part should be the authorization code
    NSString *authorizationCode = titleParts.lastObject;

    NSLog(@"Authorization code is: %@", authorizationCode);
  }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

@end
