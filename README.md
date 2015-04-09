# DANGoogleSignIn
A quick wrapper around Google's web authentication for mobile devices.

# Usage

```swift
let viewController = DANGoogleSignInViewController(clientId: "your google client id", scopes: ["your google scopes"])
navigationController.pushViewController(viewController, animated: true)
```

or in [legacy projects](https://twitter.com/ayanonagon/status/579591911935180800):
```objective-c
DANGoogleSignInViewController *viewController = [[DANGoogleSignInViewController alloc] initWithClientId:@"your google client id" scopes:@[@"your google scopes"]];
[self.navigationController pushViewController:viewController animated:YES];
```

# Installation instructions

[CocoaPods](https://cocoapods.org) is the recommended installation method.

```ruby
pod 'DANGoogleSignIn'
```
