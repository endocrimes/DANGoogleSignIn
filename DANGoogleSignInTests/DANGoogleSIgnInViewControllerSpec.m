//
//  DANGoogleSIgnInViewControllerSpec.m
//  DANGoogleSignIn
//
//  Created by Daniel Tomlinson on 08/09/2014.
//  Copyright 2014 Rocket Apps. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>

#import "DANGoogleSIgnInViewController.h"

SpecBegin(DANGoogleSIgnInViewController)

describe(@"DANGoogleSIgnInViewController", ^{
  __block DANGoogleSignInViewController *viewController;

  context(@"when initilized using the designated initiliser", ^{
    beforeEach(^{
      viewController = [[DANGoogleSignInViewController alloc] initWithClientId:@"hello"
                                                                  clientSecret:@"world"
                                                                        scopes:@[]];
    });

    it(@"should not be nil", ^{
      expect(viewController).toNot.beNil();
    });

    afterEach(^{
      viewController = nil;
    });
  });
});

SpecEnd
