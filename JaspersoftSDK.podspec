Pod::Spec.new do |s|
	s.name = "JaspersoftSDK"
	s.version = "2.2"
	s.summary = "JaspersoftSDK - The simplest way to build JasperReports Server apps."
	s.description = <<-DESC
		JaspersoftSDK for iOS is a set of Objective-C classes to easily connect
		and consume the services provided by JasperReports Server
		using the REST API (available in JasperReports Server 5.5.0 or greater).!
	DESC
	s.homepage = "http://community.jaspersoft.com/project/mobile-sdk-ios"
	s.license = { :type => "GNU GPL v.3", :file => "LICENSE.txt" }
	s.author = "TIBCO Software"
	s.platform = :ios, "8.0"
	s.source = { :git => "https://github.com/Jaspersoft/js-ios-sdk.git", :tag => "#{s.version}" }
	s.public_header_files = "Classes/**/*.h"
	
	s.prefix_header_contents = <<-EOS
		#import <SystemConfiguration/SystemConfiguration.h>
		#import <MobileCoreServices/MobileCoreServices.h>
	EOS
	s.framework = "Foundation"
	s.requires_arc = true
	
	s.dependency "RestKit/Core", "0.24.0"
	s.dependency "ServerReachability", "0.0.2"
	
	s.subspec "arc" do |sp|
	  sp.source_files = "Classes", "Classes/**/*.{h,m}"
      sp.exclude_files = "**/KeychainItemWrapper.{h,m}"
      sp.requires_arc = true
    end

    s.subspec "no-arc" do |sp|
      sp.source_files = "**/KeychainItemWrapper.{h,m}"
      sp.requires_arc = false
    end
end
