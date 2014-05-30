Pod::Spec.new do |s|
  s.name             = "PHYExtendedAppDelegate"
  s.version          = "0.1.1"
  s.summary          = "Taming UIApplication delegates."
  s.homepage         = "http://rallyapp.io"
  s.license          = 'MIT'
  s.author           = { "Matt Ricketson" => "matt@phyreup.com" }
  s.source           = { :git => "https://github.com/phyre-inc/PHYExtendedAppDelegate.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/phyreup'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.public_header_files = 'Classes/*.h'
  s.source_files = 'Classes/*.{h,m}'
end
