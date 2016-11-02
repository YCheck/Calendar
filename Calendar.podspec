#
#  Be sure to run `pod spec lint Calendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = “Calendar”  
  s.version          = "1.0.0"  
  s.summary          = “Calendar demo used on iOS."  
  s.description      = <<-DESC  
                       It is a marquee view used on iOS, which implement by Objective-C.  
                       DESC  
  s.homepage         = "https://github.com/YCheck/Calendar"
  # s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"  
  s.license          = 'MIT'  
  s.author           = { “杨成友” => “864390553@qq.com” }  
  s.source           = { :git => "https://github.com/YCheck/Calendar.git", :tag => s.version.to_s }  
  # s.social_media_url = 'https://twitter.com/NAME'  
  
  s.platform     = :ios, ‘8.0’  
  # s.ios.deployment_target = ‘8.0’  
  # s.osx.deployment_target = '10.7'  
  s.requires_arc = true  
  
  s.source_files = ‘Calendar/*’  
  # s.resources = 'Assets'  
  
  # s.ios.exclude_files = 'Classes/osx'  
  # s.osx.exclude_files = 'Classes/ios'  
  # s.public_header_files = 'Classes/**/*.h'  
  s.frameworks = 'Foundation', 'CoreGraphics', 'UIKit' 

end
