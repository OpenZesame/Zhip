source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '10.0'
inhibit_all_warnings!
use_frameworks!


workspace 'ViewComposer.xcworkspace'

def pods
  pod 'SwiftLint'
  pod 'Sourcery', '> 0.13'
end

target 'Example' do
    project 'Example/Example'
end

target 'ViewComposer' do
  project 'ViewComposer'

  pods

  target 'ViewComposerTests' do
    inherit! :search_paths
  end

end
 

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name.start_with? "Pods-"
            puts "Updating #{target.name}"
            target.build_configurations.each do |config|
                xcconfig_path = config.base_configuration_reference.real_path
                to_write = "#include \"../../../Source/Configuration/Config.xcconfig\"\n\n"
                xcconfig_contents = ""
                File.open(xcconfig_path, 'r') do |fd|
                    xcconfig_contents = to_write << fd.read
                end
                # Overwrite file but now with prepended string on it
                File.open(xcconfig_path, 'w') do |fd|
                    fd.write(xcconfig_contents)
                end
            end
        end
    end
end
