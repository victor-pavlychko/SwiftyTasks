#
# Be sure to run `pod lib lint SwiftyTasks.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name                  = 'SwiftyTasks'
    s.version               = '0.0.1'
    s.summary               = 'Task library for Swift.'

    s.description           = <<-DESC
Pragmatic approach to async tasks in Swift.
                                 DESC

    s.homepage              = 'https://github.com/victor-pavlychko/SwiftyTasks'
    s.license               = { :type => 'MIT', :file => 'LICENSE' }
    s.author                = { 'Victor Pavlychko' => 'victor.pavlychko@gmail.com' }
    s.source                = { :git => 'https://github.com/victor-pavlychko/SwiftyTasks.git', :tag => s.version.to_s }
    s.social_media_url      = 'https://twitter.com/victorpavlychko'
    s.ios.deployment_target = '8.0'
    s.source_files          = 'SwiftyTasks/**/*'
end
