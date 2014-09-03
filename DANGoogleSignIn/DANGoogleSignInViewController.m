//
//  DANGoogleSignInViewController.m
//  DANGoogleSignIn
//
//  Created by Daniel Tomlinson on 02/09/2014.
//  Copyright (c) 2014 Rocket Apps. All rights reserved.
//

#import "DANGoogleSignInViewController.h"

@interface DANGoogleSignInViewController ()
@property (nonatomic, copy) NSString *clientId;
@property (nonatomic, copy) NSString *clientSecret;
@property (nonatomic, copy) NSArray *scopes;
@end

@implementation DANGoogleSignInViewController

- (instancetype)initWithClientId:(NSString *)clientId
                    clientSecret:(NSString *)clientSecret
                          scopes:(NSArray *)scopes {
  self = [super init];
  if (self) {
    _clientId = clientId;
    _clientSecret = clientSecret;
    _scopes = scopes;
  }
  
  return self;
}

@end
