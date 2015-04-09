Pod::Spec.new do |s|
  s.name             = "DANGoogleSignIn"
  s.version          = "1.0.0"
  s.summary          = "A quick wrapper around Google's web authentication for mobile devices."
  s.homepage         = "https://github.com/endocrimes/DANGoogleSignIn"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Danielle Lancashire" => "dani@builds.terrible.systems" }
  s.social_media_url = "https://twitter.com/endocrimes"
	s.platform         = :ios, "7.0"
  s.source           = { :git => "https://github.com/endocrimes/DANGoogleSignIn.git", :tag => s.version }
  s.source_files     = "DANGoogleSignIn", "DANGoogleSignIn/**/*.{h,m}"
  s.requires_arc     = true
end
