Pod::Spec.new do |s|

  s.name         = "ZXLBaseLibrary"
  s.version      = "1.0.1"
  s.summary      = "基础组件"
  s.homepage     = "https://github.com/ZXLBoaConstrictor"
  s.license      = "MIT"
  s.author             = { "zhangxiaolong" => "244061043@qq.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/ZXLBoaConstrictor/ZXLBaseLibrary.git", :tag => "#{s.version}" }
  s.source_files  = "ZXLBaseLibrary/Classes/*.{h,m}"
	

  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.xcconfig = { "OTHER_LDFLAGS" => "-w" }
end
