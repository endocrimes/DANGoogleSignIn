//
//  DANGoogleSignInWebView.h
//  DANGoogleSignIn
//
//  Created by Daniel Tomlinson on 02/09/2014.
//  Copyright (c) 2014 Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DANGoogleSignInAuthorizationDelegate <NSObject>

- (void)didRecieveAuthorizationToken:(NSString *)authorizationToken;

@end

@interface DANGoogleSignInWebView : UIWebView

@end
