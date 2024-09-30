#
#  Be sure to run `pod spec lint gsl-ios.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "gsl-ios"
  spec.version      = "2.8.0"
  spec.summary      = "iOS frameworks and cocoapods for GNU Scientific Library"

  spec.description  = <<-DESC
                   DESC

  spec.homepage     = "https://github.com/inpulse-vet/gsl-ios"

  spec.license      = { :type => "GPLv3", :file => "LICENSE" }

  spec.author             = { "INpulse" => "contato@inpulse.vet" }

  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.14"
  
  spec.static_framework = true
  spec.source_files = "Headers/**/*.h"
  spec.libraries: "c",

  spec.source       = { :git => "https://github.com/inpulse-vet/gsl-ios.git", :tag => "v#{spec.version}" }

  spec.vendored_frameworks = "libgsl.framework", "libgslcblas.xcframework"

end
