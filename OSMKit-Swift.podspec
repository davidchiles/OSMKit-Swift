Pod::Spec.new do |spec|
  spec.name         = 'OSMKit-Swift'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/davidchiles/OSMKit-Swift'
  spec.version      = '0.1'
  spec.summary      = 'OpenStreetMap library for iOS and OS X'
  spec.source       = { :git => 'https://github.com/davidchiles/OSMKit-Swift', :tag => spec.version }
  spec.requires_arc = true


  spec.platform     = :ios, "9.0"



  spec.source_files = 'Source/**/*.swift'
end
