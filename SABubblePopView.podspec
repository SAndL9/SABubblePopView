

Pod::Spec.new do |s|



  s.name         = "SABubblePopView"
  s.version      = "0.0.1"
  s.summary      = "气泡弹出框"
  s.platform     = :ios, '8.0'

  s.homepage     = "http://github.com/SAndL9/SABubblePopView"

  s.license      = "MIT"

  s.requires_arc = true
  s.author             = { "李磊" => "lilei@iscs.com.cn" }


  s.source       = { :git => "http://github.com/SAndL9/SABubblePopView.git", :tag => s.version.to_s }



    s.subspec 'SABubblePopView' do |ss|
    ss.source_files = 'SABubblePopView/SABubblePopView/SABubblePopView/*.{h,m}'
    end




end
