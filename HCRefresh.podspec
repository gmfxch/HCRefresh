Pod::Spec.new do |s|
  s.name         = 'HCRefresh'
  s.version      = '1.2.2'
  s.summary      = "An easy way to use pull-to-refresh"
  s.homepage     = "https://github.com/gmfxch/HCRefresh"
  s.license      = "MIT"
  s.authors      = {'hao chen' => '1119799601@qq.com'}
  s.platform     = :ios, '7.0'
  s.source       = {:git => 'https://github.com/gmfxch/HCRefresh.git', :tag => s.version}
  s.source_files = 'HCRefresh/**/*.{h,m}'
  s.requires_arc = true
  s.public_header_files = 'HCRefresh/**/*.h'
end