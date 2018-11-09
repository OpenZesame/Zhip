platform :ios, '11.0'
inhibit_all_warnings!
use_modular_headers!

def shared
  # The Zilliqa Swift SDK
  pod 'Zesame', :git => 'https://github.com/OpenZesame/Zesame.git', :branch => 'master'

  # RxSwift made this app
  pod 'RxCocoa'

  # Code convention linter
  pod 'SwiftLint'

  # Logging in the app
  pod 'SwiftyBeaver' 
  
  # Autolayout easy
  pod 'TinyConstraints'

  # Generate QR code
  pod 'EFQRCode'

  # Keychain made simple
  pod 'KeychainSwift'

  # Simple keyboard avoiding solution
  pod 'IQKeyboardManagerSwift'

  pod 'JSONRPCKit', :git => 'https://github.com/ollitapa/JSONRPCKit.git', :branch => 'master'

  pod 'SwiftGen'
end

target 'Zupreme' do
  shared

  target 'ZupremeTests' do
    inherit! :search_paths
    pod 'RxTest'
    pod 'RxBlocking'
  end
end

pods_lacking_swift_version_build_setting = [
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
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
          if pods_lacking_swift_version_build_setting.include?(target.name)
            config.build_settings['SWIFT_VERSION'] = '4.2'
          end
        end
    end
end
