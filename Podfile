# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/it-boyer/PodRepo.git'

target 'MusicLrcUtil' do
    platform :ios, '13.0'
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'MusicLrc', :path => './'
  target 'LrcTestTests' do
    inherit! :search_paths
    # Pods for testing
    pod 'Quick'
    pod 'Nimble'
  end

end

