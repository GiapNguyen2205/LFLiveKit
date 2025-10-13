
Pod::Spec.new do |s|

  s.name         = "LFLiveKit"
  s.version      = "2.6.2"
  s.summary      = "LaiFeng ios Live. LFLiveKit with 8+ custom filters support."
  s.description  = "Enhanced LFLiveKit with 8+ custom filters including Sepia, Blur, Sharpen, Emboss, Edge Detection, Black & White, Vintage, and Vivid filters. Perfect for live streaming with advanced video effects."
  s.homepage     = "https://github.com/GiapNguyen2205/LFLiveKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "GiapNguyen" => "giapnguyen220503@gmail.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/GiapNguyen2205/LFLiveKit.git", :branch => "custom-filter" }
  s.source_files  = "LFLiveKit/**/*.{h,m,mm,cpp,c}"
  s.public_header_files = ['LFLiveKit/*.h', 'LFLiveKit/objects/*.h', 'LFLiveKit/configuration/*.h', 'LFLiveKit/filter/*.h', 'LFLiveKit/capture/*.h']
  s.frameworks = "VideoToolbox", "AudioToolbox","AVFoundation","Foundation","UIKit"
  s.libraries = "c++", "z"

  s.requires_arc = true
end
