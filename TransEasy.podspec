#
# Be sure to run `pod lib lint TransEasy.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TransEasy'
  s.version          = '0.5.1'
  s.summary          = 'A simple way to have gorgeous transitions.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Ever wanted to have that gorgeous zoom transition with your segues but hesitated because it looked way too complex to implement? Well, I thought it is too complex too! Custom Transitions shouldn't be this complex.
                       DESC

  s.homepage         = 'https://github.com/mohpor/TransEasy'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author           = { 'M. Porooshani' => 'porooshani@gmail.com' }
  s.source           = { :git => 'https://github.com/mohpor/TransEasy.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/mohpor'

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*'
  
  # s.resource_bundles = {
  #   'TransEasy' => ['TransEasy/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
