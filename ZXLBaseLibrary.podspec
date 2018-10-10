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
  #基础工具
  s.subspec 'ZXLUtils' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Utils/*.{h,m}'
  end
  #基础扩展
  s.subspec 'ZXLExtension' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Extension/*.{h,m}'
  end
  #基础路由
  s.subspec 'ZXLRouter' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Router/*.{h,m}'
  end
  #基础自定义VC +View
  s.subspec 'ZXLCustom' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Custom/*.{h,m}'
  end
  
  #设置中心
  s.subspec 'ZXLSetting' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Setting/*.{h,m}'
      ss.dependency 'ZXLBaseLibrary/ZXLExtension'
  end
  
  #网络请求包含socket
  s.subspec 'ZXLNetWork' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/NetWork/*.{h,m}'
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'AFNetworking'
      ss.dependency 'CocoaAsyncSocket'
      ss.dependency 'SVProgressHUD'
  end
  
  #语音处理中心
  s.subspec 'ZXLVoice' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Voice/*.{h,m}'
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/Voice/Framework/lame.framework']
      ss.dependency 'ZXLBaseLibrary/ZXLExtension'
      ss.frameworks = 'AVFoundation'
  end
  #网页处理中心（jsbridge 和网页请求拦截处理）
  s.subspec 'ZXLWeb' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Web/*.{h,m}'
  end
  #播放器
  s.subspec 'ZXLPlayer' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/Player/*.{h,m}'
      ss.resources = ['ZXLBaseLibrary/Classes/Player/Resource/ZFPlayer.bundle']
      ss.dependency 'Masonry'
  end
  #上传下载
  s.subspec 'ZXLUploadDownload' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/UploadDownload/*.{h,m}'
  end
  #崩溃记录
  s.subspec 'ZXLCrashUtils' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/CrashUtils/*.{h,m}'
      ss.dependency 'Bugly'
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
  end
  #相册
  s.subspec 'ZXLImagePicker' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/ImagePicker/*.{h,m}'
      ss.resources = ['ZXLBaseLibrary/Classes/ImagePicker/Resource/TZImagePickerController.bundle']
      ss.dependency 'SVProgressHUD'
      ss.frameworks = 'ImageIO','AssetsLibrary','MediaPlayer'
  end
  #支付
  s.subspec 'ZXLPayUtils' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/PayUtils/*.{h,m}'
  end
  #推送
  s.subspec 'ZXLPushMessage' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/PushMessage/*.{h,m}'
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/PushMessage/Framework/GTSDK.framework']
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'ZXLBaseLibrary/ZXLRouter'
      ss.frameworks = 'UserNotifications'
  end
  #第三方（微信、微博、QQ等）
  s.subspec 'ZXLThirdParty' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/ThirdParty/*.{h,m}'
  end
  

  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.xcconfig = { 'OTHER_LDFLAGS' => '-w' }
end
