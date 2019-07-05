#
# Be sure to run `pod lib lint TLMToolKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TLMToolKit'
  s.version          = '0.1.2'
  s.summary          = 'A short description of TLMToolKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/tom555cat/TLMToolKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TongLeimign' => 'tongleiming1989@sina.com' }
  s.source           = { :git => 'https://github.com/tom555cat/TLMToolKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.source_files = 'TLMToolKit/**/*'
  
  s.subspec 'TLMRegisterInitFunc' do |registerInitFunc|
    registerInitFunc.source_files  = "TLMToolKit/TLMRegisterInitFunc/*.{h,m}"
    registerInitFunc.public_header_files = "TLMToolKit/TLMRegisterInitFunc/*.h"
  end
  
  s.subspec 'TLMNetwork' do |network|
    network.source_files  = "TLMToolKit/TLMNetwork/*.{h,m}"
    network.public_header_files = "TLMToolKit/TLMNetwork/*.h"
  end
  
  s.subspec 'TLMLogger' do |logger|
    logger.source_files  = "TLMToolKit/TLMLogger/*.{h,m}"
    logger.public_header_files = "TLMToolKit/TLMLogger/*.h"
  end
  
  s.subspec 'TLMMonitor' do |monitor|
    monitor.source_files  = "TLMToolKit/TLMMonitor/*.{h,m}"
    monitor.public_header_files = "TLMToolKit/TLMMonitor/*.h"
  end
  
#  s.subspec 'TLMStackTrack' do |stackTrack|
#    stackTrack.source_files  = "TLMToolKit/TLMStackTrack/*.{h,m}"
#    stackTrack.public_header_files = "TLMToolKit/TLMStackTrack/*.h"
#  end
#  
#  s.subspec 'TLMOutOfMemory' do |outOfMemory|
#    outOfMemory.source_files  = "TLMToolKit/TLMOutOfMemory/*.{h,m}"
#    outOfMemory.public_header_files = "TLMToolKit/TLMOutOfMemory/*.h"
#  end
  
  # s.resource_bundles = {
  #   'TLMToolKit' => ['TLMToolKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PLCrashReporter', '~> 1.2'
  s.dependency 'AFNetworking'
  s.dependency 'FBAllocationTracker'
end
