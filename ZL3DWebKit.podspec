#
# Be sure to run `pod lib lint ZL3DWebKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZL3DWebKit'
  s.version          = '0.1.0'
  s.summary          = 'A short description of ZL3DWebKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/luokan/ZL3DWebKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'luokan' => 'kanluo91@yahoo.com' }
  s.source           = { :git => 'https://github.com/luokan/ZL3DWebKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.static_framework = true

  s.source_files = 'ZL3DWebKit/Classes/**/*'
  
  s.resource_bundles = {
     'ZL3DWebKit' => ['ZL3DWebKit/Assets/*']
  }
  
  s.resource = 'ZL3DWebKit/ZL3DWeb.bundle'
  
  s.resources = ['ZL3DWebKit/ZL3DWeb.bundle','ZL3DWebKit/ZL3DWeb009.bundle']


  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'JKSandBoxManager'
  s.dependency 'SSZipArchive'
end
