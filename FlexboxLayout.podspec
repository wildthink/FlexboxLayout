Pod::Spec.new do |s|
  s.name = 'FlexboxLayout'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'CSS Flexbox Layout in Swift'
  s.homepage = 'https://github.com/wildthink/FlexboxLayout'
  s.authors = { 'Alex Usbergo' => 'alexakadrone@gmail.com', 'Jason Jobe' => 'github@jasonjobe.com' }
  s.source = { :git => 'https://github.com/wildthink/FlexboxLayout.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.10'
  s.tvos.deployment_target = '9.0'

  s.source_files = 'FlexboxLayout/*'
end
