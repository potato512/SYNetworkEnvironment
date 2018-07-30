Pod::Spec.new do |s|
  s.name         = "SYNetworkEnvironment"
  s.version      = "1.2.2"
  s.summary      = "SYNetworkEnvironment is used for setting network host as easy as possible."
  s.homepage     = "https://github.com/potato512/SYNetworkEnvironment"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "herman" => "zhangsy757@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/potato512/SYNetworkEnvironment.git", :tag => s.version.to_s }
  s.source_files = 'SYNetworkEnvironment/*.{h,m}'
  s.requires_arc = true
  s.frameworks = 'UIKit', 'CoreFoundation'
end
