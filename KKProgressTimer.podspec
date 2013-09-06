Pod::Spec.new do |s|
  s.platform     = :ios, '5.0'
  s.name         = "KKProgressTimer"
  s.version      = "0.0.1"
  s.summary      = "simple circle progress view."
  s.license      = { :type => 'MIT', :file => 'LICENSE.txt' }
  s.author       = { "gin0606" => "kkgn06@gmail.com" }
  s.homepage     = 'https://github.com/gin0606/KKProgressTimer'
  s.source       = { :git => "http://github.com/gin0606/KKProgressTimer.git", :tag => "0.0.1" }
  s.source_files = 'KKProgressTimer/*.{h,m}'
  s.requires_arc = true
end
