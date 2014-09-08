//
//  DANGoogleSignInViewController.h
//  DANGoogleSignIn
//
//  Created by  Danielle Lancashireon 02/09/2014.
//  Copyright (c) 2014 Rocket Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DANGoogleSignInViewController : UIViewController

/**
 *  Create a new instance of DANGoogleSignInViewController. 
 *  This is the Designated initializer.
 *
 *  @param clientId     The Google Client ID
 *  @param clientSecret The Google Client Secret
 *  @param scopes       The Required Scopes
 *
 *  @return <#return value description#>
 */
- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                          scopes:(NSArray *)scopes;

@property (nonatomic, copy) void (^successBlock)(NSString *authorizationToken);
@property (nonatomic, copy) void (^failureBlock)(NSError *error, NSString *googleErrorMessage);

@end
