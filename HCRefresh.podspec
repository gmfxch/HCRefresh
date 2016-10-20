Pod::Spec.new do |s|
  s.name         = 'HCRefresh'
  s.version      = '1.1.1'
  s.summary      = "An easy way to use pull-to-refresh"
  s.homepage     = "https://github.com/gmfxch/HCRefresh"
  s.license      = "MIT"
  s.authors      = {'hao chen' => '1119799601@qq.com'}
  s.platform     = :ios, '7.0'
  s.source       = {:git => 'https://github.com/gmfxch/HCRefresh.git', :tag => s.version}
  s.source_files = 'HCRefresh', 'HCRefresh/**/*.{h,m}'
  s.requires_arc = true
end