//
//  DANGoogleSignInViewController.h
//  DANGoogleSignIn
//
//  Created by  Danielle Lancashireon 02/09/2014.
//  Copyright (c) 2014 Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DANGoogleSignInViewController : UIViewController

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                          scopes:(NSArray *)scopes;

@property (nonatomic, copy) void (^successBlock)(NSString *authorizationToken);
@property (nonatomic, copy) void (^failureBlock)(NSError *error, NSString *googleErrorMessage);

@end
