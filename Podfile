platform :ios, '11.0'
inhibit_all_warnings!
use_modular_headers!

def shared
  # The Zilliqa Swift SDK
  pod 'Zesame', :git => 'https://github.com/OpenZesame/Zesame.git', :branch => 'master'

  # Used for logging, search for "TrackableEvent" in the code base to see which events
  # are being logged
  pod 'Firebase/Core'
  pod 'Fabric', '~> 1.9.0'
  pod 'Crashlytics', '~> 3.12.0'

  # RxSwift made this app
  pod 'RxCocoa'

  # Reactive Table and CollectionView
  pod 'RxDataSources'

  # Code convention linter
  pod 'SwiftLint'

  # Logging in the app
  pod 'SwiftyBeaver' 
  
  # Autolayout easy
  pod 'TinyConstraints'

  # UITextField with placeholder that animates on top of the field
  pod 'SkyFloatingLabelTextField'

  # UIView agnostic aggregatable rules for valdation in input 
  pod 'Validator'

  # Generate QR code
  pod 'EFQRCode'

  # Scan QR Code
  pod 'QRCodeReader.swift'

  # Keychain made simple
  pod 'KeychainSwift'

  # Simple keyboard avoiding solution
  pod 'IQKeyboardManagerSwift'

  pod 'JSONRPCKit', :git => 'https://github.com/ollitapa/JSONRPCKit.git', :branch => 'master'

  pod 'SwiftGen'

  pod 'M13Checkbox'

  # "just now" / "One week ago" / "2 months ago"
  pod 'DateToolsSwift'
end

target 'Zhip' do
  shared

  target 'ZhipTests' do
    inherit! :search_paths
    pod 'RxTest'
    pod 'RxBlocking'
  end
end

pods_to_set_swift_verstion_to_42 = [
  'BigInt',
  'IQKeyboardManagerSwift',
  'JSONRPCKit',
  'RxAtomic',
  'RxBlocking',
  'RxCocoa',
  'RxSwift',
  'RxTest',
  'SipHash',
  'SwiftyBeaver',
  'TinyConstraints',
]
    
post_install do |installer|
  # Acknowledgments: https://github.com/CocoaPods/CocoaPods/wiki/Acknowledgements
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-Zhip/Pods-Zhip-acknowledgements.plist', 'Source/Application/Assets/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

  installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|

        if pods_to_set_swift_verstion_to_42.include?(target.name)
          config.build_settings['SWIFT_VERSION'] = '4.2'
        end

      end
  end
end