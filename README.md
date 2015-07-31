Jaspersoft Mobile SDK for iOS
=============================

The Jaspersoft Mobile SDK for iOS provides a library, samples, and documentation for developers to build mobile applications based on Jaspersoft JasperReports Server web services.

The interaction with JasperReports Server is based on the REST APIs that come with JasperReports Server 4.7.1 and later.


General Information
--------------------

Please see the Jaspersoft Mobile SDK for iOS Community project page:
http://community.jaspersoft.com/project/mobile-sdk-ios

Installation
------------

The recommended approach for installing JaspersoftSDK is via the [CocoaPods](http://cocoapods.org/) package manager, as it provides flexible dependency management and dead simple installation. For best results, it is recommended that you install via CocoaPods **>= ** 0.19.1g Git **>= 1.8.0** installed via Homebrew.

### via CocoaPods

Install CocoaPods if not already available:

``` bash
$ [sudo] gem install cocoapods
$ pod setup
```

Change to the directory of your Xcode project, and Create and Edit your Podfile and add JaspersoftSDK:

``` bash
$ cd /path/to/MyProject
$ touch Podfile
$ edit Podfile
platform :ios, '6.0' 
# Or platform :osx, '10.7'
pod 'JaspersoftSDK', :git => 'https://github.com/Jaspersoft/js-ios-sdk.git', :tag => '2.0.2'
post_install do |installer_representation|
  installer_representation.project.targets.each do |target|
    if target.name == "Pods-JaspersoftSDK"
      target.build_configurations.each do |config|
        if config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] |= ['$(inherited)']
        elsif
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
        end

        if config.name == 'Debug'
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] |= ['__DEBUG__']
        elsif config.name == 'Adhoc'
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] |= ['__ADHOC__']
        elsif config.name == 'Release'
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] |= ['__RELEASE__']
        end      
      end
    end
  end
end
```

Install into your project:

``` bash
$ pod install
```

Open your project in Xcode from the .xcworkspace file (not the usual project file)

``` bash
$ open MyProject.xcworkspace
```

License
-------

JaspersoftSDK is licensed under the terms of the [GNU LESSER GENERAL PUBLIC LICENSE, version 3.0](http://www.gnu.org/licenses/lgpl). Please see the [LICENSE](LICENSE) file for full details.