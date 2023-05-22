#
# Be sure to run `pod lib lint XCAlphaVideoPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XCAlphaVideoPlayer'
  s.version          = '1.0.10'
  s.summary          = 'A short description of XCAlphaVideoPlayer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chengssir/XCAlphaVideoPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'guoshuai.cheng@holla.world' => 'guoshuai.cheng@holla.world' }
  s.source           = { :git => 'https://github.com/chengssir/XCAlphaVideoPlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

   if ENV['use_code'] or ENV[s.name+'_use_code']
    s.source_files = 'XCAlphaVideoPlayer/Classes/**/*'
   else #Framework模式
     s.ios.vendored_frameworks = 'Frameworks/XCAlphaVideoPlayer.xcframework'
     s.source_files = 'XCAlphaVideoPlayer/Classes/**/*.h'
   end
  
  s.resource_bundles = {
    'XCAlphaVideoPlayer' => ['XCAlphaVideoPlayer/Classes/BDAlphaPlayer/**/*.metal']
  }
  
  s.libraries = 'c++'

  s.frameworks = 'UIKit','CoreVideo'

end
