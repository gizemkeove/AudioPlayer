#
# Be sure to run `pod lib lint GlobalEventHub.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GlobalEventHub'
  s.version          = '1.0.0'
  s.summary          = 'Fire and receive events from ANYWHERE in your app'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'You can fire events from anywhere in the application, a view, a controller a cell or any other object. You can receive these events from anywhere in your app with a single delegate method'

  s.homepage         = 'https://github.com/keove/GlobalEventHub-iOS.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'cozdes' => 'cagri.ozdes@keove.com' }
  s.source           = { :git => 'https://github.com/keove/GlobalEventHub-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'GlobalEventHub/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GlobalEventHub' => ['GlobalEventHub/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
