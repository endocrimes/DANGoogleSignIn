Pod::Spec.new do |s|
  s.name             = "DANGoogleSignIn"
  s.version          = "1.0.0"
  s.summary          = "A quick wrapper around Google's web authentication for mobile devices."
  s.homepage         = "https://github.com/DanielTomlinson/DANGoogleSignIn"
  s.license          = { :type => "MIT", :file => "LICENSE" }
  s.author           = { "Daniel Tomlinson" => "dan@tomlinson.io" }
  s.social_media_url = "https://twitter.com/DanToml"
	s.platform         = :ios, "7.0"
  s.source           = { :git => "https://github.com/DanielTomlinson/DANGoogleSignIn.git", :tag => s.version }
  s.source_files     = "DANGoogleSignIn", "DANGoogleSignIn/**/*.{h,m}"
  s.requires_arc     = true
end
