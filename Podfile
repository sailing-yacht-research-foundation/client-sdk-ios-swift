workspace 'SYRFClient.xcworkspace'
platform :ios, '13.0'

source 'https://github.com/Cocoapods/Specs.git'

def shared_pods

end

def time_pods

    pod 'Kronos'
  
end

def geospacial_pods

    pod 'GEOSwift'

end

project 'SYRFTime/SYRFTime.xcodeproj'
project 'SYRFLocation/SYRFLocation.xcodeproj'
project 'SYRFNavigation/SYRFNavigation.xcodeproj'
project 'SYRFGeospatial/SYRFGeospatial.xcodeproj'

target :SYRFTime do

    project 'SYRFTime/SYRFTime.xcodeproj'
    shared_pods
    time_pods
  
end

target :SYRFGeospatial do

    use_frameworks!
    project 'SYRFGeospatial/SYRFGeospatial.xcodeproj'
    shared_pods
    geospacial_pods

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('9.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
      end
    end
  end
end

