#
#  Be sure to run `pod spec lint gsl-ios.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "libgsl"
  spec.version      = "2.8.0"
  spec.summary      = "iOS pod for GNU Scientific Library"
  spec.source       = { :http => "https://github.com/inpulse-vet/gsl-ios/releases/download/2.8.0/pod-libgsl-2.8.0.zip" }

  spec.description  = <<-DESC
  GNU Scientific Library built for platforms:
    - iOS arm64
    - iOS Simulator arm64
    - macOS arm64 and x86_64
                   DESC

  spec.homepage     = "https://github.com/inpulse-vet/gsl-ios"

  spec.license      = { :type => "GPLv3", :file => "LICENSE" }

  spec.author             = { "INpulse" => "contato@inpulse.vet" }

  spec.ios.deployment_target = "12.0"
  spec.osx.deployment_target = "10.14"
  
  spec.static_framework = true
  spec.source_files = "Headers/**/*.h"
  spec.libraries = "c",

  spec.vendored_frameworks = "gsl.xcframework", "gslcblas.xcframework"

end
