Pod::Spec.new do |s|
	s.name = 'JaspersoftSDK'
	s.version = '2.3-beta'
	s.summary = 'JaspersoftSDK - The simplest way to build JasperReports Server apps.'
	s.description = <<-DESC
		JaspersoftSDK for iOS is a set of Objective-C classes to easily connect
		and consume the services provided by JasperReports Server
		using the REST API (available in JasperReports Server 5.5.0 or greater).!
	DESC
	s.homepage = 'http://community.jaspersoft.com/project/mobile-sdk-ios'
	s.license = { :type => 'GNU GPL v.3', :file => 'LICENSE.txt' }
	s.author = 'TIBCO Software'
	s.platform = :ios, '6.0'
	s.source = { :git => 'https://github.com/Jaspersoft/js-ios-sdk.git', :tag => s.version.to_s }
	s.public_header_files = "Sources/*.h"
	s.framework = 'Foundation'	

	# Platform setup
	s.requires_arc = true
	s.ios.deployment_target = '7.0'

	s.default_subspec = 'JSCore'

    # Preserve the layout of headers in the Sources directory
    s.header_mappings_dir = 'Sources'

	### Subspecs	
	s.subspec 'JSCore' do |jscSpec|	
		jscSpec.dependency 'JaspersoftSDK/Resources'
    	jscSpec.dependency 'RestKit/Core', '~> 0.24.0'
		jscSpec.dependency 'ServerReachability'
		
		jscSpec.subspec 'JSHelper' do |jshSpec|
    		jshSpec.source_files = 'Sources/JSHelper'
		end
		jscSpec.subspec 'JSObjectMappings' do |jsomSpec|
    		jsomSpec.source_files = 'Sources/JSObjectMappings'
		end
		jscSpec.subspec 'JSRestClient' do |jsrcSpec|
			jsrcSpec.subspec 'KeychainItemWrapper' do |jskiwSpec|
    			jskiwSpec.source_files = 'Sources/JSRestClient/KeychainItemWrapper'
    			jskiwSpec.requires_arc = false
			end
    		jsrcSpec.source_files = 'Sources/JSRestClient'
		end
		
		jscSpec.prefix_header_contents = <<-EOS
			#import <Availability.h>
			#define _AFNETWORKING_PIN_SSL_CERTIFICATES_
			#if __IPHONE_OS_VERSION_MIN_REQUIRED
			  #import <SystemConfiguration/SystemConfiguration.h>
			  #import <MobileCoreServices/MobileCoreServices.h>
			  #import <Security/Security.h>
			#else
			  #import <SystemConfiguration/SystemConfiguration.h>
			  #import <CoreServices/CoreServices.h>
			  #import <Security/Security.h>
			#endif
		EOS
	end
	s.subspec 'Resources' do |resSpec|
		resSpec.ios.resource_bundle = { 'JaspersoftSDK' => 'Resources/Localizable/*.lproj' }
	end

	s.subspec 'JSSecurity' do |jssSpec|
    	jssSpec.source_files = 'Sources/JSSecurity.h', 'Sources/JSSecurity'
	end
	
	s.subspec 'JSReportExtention' do |jsreSpec|
	    jsreSpec.dependency 'JaspersoftSDK/JSCore'
    	jsreSpec.source_files = 'Sources/JSReportExtention.h', 'Sources/JSReportExtention'
	end

end