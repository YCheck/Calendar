#  Be sure to run `pod spec lint Calendar.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = 'Calendar' 
  s.version          = '1.0.0.0'  
  s.summary          = 'Calendar demo used on iOS.'    
  s.homepage         = 'https://github.com/YCheck/Calendar'
  s.license          = {:type => 'MIT'}  
  s.authors          = { 'NULL' => '864390553@qq.com' }  
  s.source           = { :git => 'https://github.com/YCheck/Calendar.git', :tag => '1.0.0.0' }
  s.source_files = 'calendar/*' 
  s.framework        = 'SystemConfiguration'
  s.ios.framework    = 'UIKit' 
end
