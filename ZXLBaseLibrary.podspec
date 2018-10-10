Pod::Spec.new do |s|

  s.name         = 'ZXLBaseLibrary'
  s.version      = '1.0.1'
  s.summary      = '基础组件'
  s.homepage     = 'https://github.com/ZXLBoaConstrictor'
  s.license      = 'MIT'
  s.author             = { 'zhangxiaolong' => '244061043@qq.com' }
  s.platform     = :ios, '9.0'
  s.source       = { :git => 'https://github.com/ZXLBoaConstrictor/ZXLBaseLibrary.git", :tag => "#{s.version}' }
  s.source_files  = 'ZXLBaseLibrary/Classes/*.{h,m}'
  s.subspec 'ZXLUtils' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Utils/*.{h,m}'
  end
  
  s.subspec 'ZXLExtension' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Extension/*.{h,m}'
  end
  
  s.subspec 'ZXLRouter' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Router/*.{h,m}'
  end
  
  s.subspec 'ZXLCustom' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Custom/*.{h,m}'
  end
  
  s.subspec 'ZXLSetting' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Setting/*.{h,m}'
  end

  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.xcconfig = { 'OTHER_LDFLAGS' => '-w' }
end
