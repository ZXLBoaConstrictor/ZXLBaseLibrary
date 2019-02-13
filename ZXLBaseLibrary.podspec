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
      ss.subspec 'ZXLCustomView' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/CustomView/*.{h,m}'
      end
      
      ss.subspec 'ZXLCustomVC' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/CustomVC/*.{h,m}'
      end
      
      ss.subspec 'ZXLTableView' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/TableView/*.{h,m}'
          sss.dependency 'ZXLBaseLibrary/ZXLCustom/ZXLCustomVC'
      end
      
      ss.subspec 'ZXLPopView' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/PopView/*.{h,m}'
      end
      
      ss.subspec 'ZXLActionSheet' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/ActionSheet/*.{h,m}'
          sss.dependency 'ZXLBaseLibrary/ZXLCustom/ZXLTableView'
      end
      
      ss.subspec 'ZXLHorizontalView' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/Custom/HorizontalView/*.{h,m}'
          sss.dependency 'ZXLBaseLibrary/ZXLCustom/ZXLCustomView'
      end
      
      ss.dependency 'ZXLBaseLibrary/ZXLExtension'
      ss.dependency 'ZXLBaseLibrary/ZXLRouter'
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'MJRefresh'
      ss.dependency 'Masonry'
      ss.dependency 'SDWebImage'
      ss.dependency 'SVProgressHUD'
      ss.frameworks = 'UIKit','Foundation','MessageUI'
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
      ss.dependency 'ZXLBaseLibrary/ZXLCustom/ZXLCustomVC'
      ss.dependency 'SDWebImage'
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
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/UploadDownload/Framework/AliyunOSSiOS.framework']
      ss.subspec 'ZXLDownload' do |sss|
          sss.source_files = 'ZXLBaseLibrary/Classes/UploadDownload/ZFDownload/*.{h,m}'
          sss.dependency 'AFNetworking'
      end
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'ZXLBaseLibrary/ZXLNetWork'
      ss.dependency 'ZXLBaseLibrary/ZXLSetting'
      ss.dependency 'FMDB'
      ss.dependency 'ZXLUpload'
      ss.dependency 'KTVHTTPCache'
      
      ss.frameworks = 'SystemConfiguration','CoreTelephony'
      ss.libraries = 'resolv'
      ss.compiler_flags = '-Wno-format'
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
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/PayUtils/Framework/AlipaySDK.framework']
      ss.resources = ['ZXLBaseLibrary/Classes/PayUtils/Resource/AlipaySDK.bundle']
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'SVProgressHUD'
      ss.dependency 'WechatOpenSDK'
      ss.frameworks = 'CoreMotion'
  end
  #推送
  s.subspec 'ZXLPushMessage' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/PushMessage/*.{h,m}'
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/PushMessage/Framework/GTSDK.framework']
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'ZXLBaseLibrary/ZXLRouter'
      ss.frameworks = 'UserNotifications'
  end
  #第三方（微信、QQ等）
  s.subspec 'ZXLThirdParty' do |ss|
      ss.source_files = 'ZXLBaseLibrary/Classes/ThirdParty/*.{h,m}'
      ss.vendored_frameworks =  ['ZXLBaseLibrary/Classes/ThirdParty/Framework/TencentOpenAPI.framework']
      ss.resources = ['ZXLBaseLibrary/Classes/ThirdParty/Resource/TencentOpenApi_IOS_Bundle.bundle']
      ss.dependency 'ZXLBaseLibrary/ZXLUtils'
      ss.dependency 'ZXLBaseLibrary/ZXLRouter'
      ss.dependency 'SVProgressHUD'
      ss.dependency 'WechatOpenSDK'
  end
  

  s.frameworks = 'UIKit','Foundation'
  s.requires_arc = true
  s.xcconfig = { 'OTHER_LDFLAGS' => '-w' }
end
