Pod::Spec.new do |spec|
  spec.name         = "CustomAVPlayer"
  spec.version      = "1.0.0"
  spec.summary      = "A customizable AVPlayer."
  spec.description  = "A framework which can be used to customize all the controls of AVPlayer directly from Storyboard."
  spec.homepage     = "https://github.com/Vikram-Chicmic/ios-video-player.git"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Vikram Kumar" => "vikram.kumar@chicmic.co.in" }
  spec.platform     = :ios, "13.0"
   spec.source = { :git => "https://github.com/Vikram-Chicmic/ios-video-player.git", :branch => "feature/reel-functions" }
  spec.source_files = "CustomAVPlayer/**/*.{swift,h}"
  spec.exclude_files = "VideoPlayer/CustomAVPlayer/CustomAVPlayerTests"
  spec.resource_bundles = {
  'CustomAVPlayer' => ['CustomAVPlayer/Cell/*.xib', 'CustomAVPlayer/Views/*.xib']
}
  spec.frameworks   = "UIKit", "AVFoundation"
  spec.swift_version = "5.0"
end
