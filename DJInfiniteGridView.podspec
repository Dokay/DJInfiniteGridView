Pod::Spec.new do |s|

  s.name         = "DJInfiniteGridView"
  s.version      = "0.1.0"
  s.summary      = "This is a custom view for scrollView"
  s.homepage     = "https://github.com/Dokay/DJInfiniteGridView"
  s.license     = { :type => "MIT", :file => "LICENSE" }
  
  s.author             = { "Dokay" => "dokay_dou@163.com" }
  # Or just: s.author    = "Dokay"
  # s.authors            = { "Dokay" => "dokay_dou@163.com" }
  # s.social_media_url   = "http://twitter.com/Dokay"

  s.platform     = :ios, "6.0"

  s.source       = { :git => "https://github.com/Dokay/DJInfiniteGridView.git", :commit => "37057bbcc589f387d33a13d56ec288d34ff3f8a3" }
  
  s.source_files  = "DJInfiniteGridView", "DJInfiniteGridView/**/*.{h,m}"
  s.public_header_files = "DJInfiniteGridView/**/*.h"
  s.requires_arc = true

end
#pod lib lint --verbose --allow-warnings
#pod repo push DJHubSpecs DJInfiniteGridView.podspec --verbose --allow-warnings
