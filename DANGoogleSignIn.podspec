Pod::Spec.new do |s|
  s.name             = "DANGoogleSignIn"
  s.version          = "0.0.1"
  s.summary          = "A quick wrapper around Google's web authentication for mobile devices."
  s.homepage         = "http://github.com/endocrimes/DANGoogleSignIn"
  s.license          = "MIT"
  s.author           = { "Danielle Lancashire" => "dani@builds.terrible.systems" }
  s.social_media_url = "http://twitter.com/endocrimes"
  s.platform         = :ios
  s.source           = { :git => "http://github.com/endocrimes/DANGoogleSignIn.git" }
  s.source_files     = "DANGoogleSignIn", "DANGoogleSignIn/**/*.{h,m}"
  s.requires_arc     = true
end
