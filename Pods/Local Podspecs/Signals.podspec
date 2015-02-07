Pod::Spec.new do |s|
  s.name = 'Signals'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.summary = 'A micro-framework for creating and observing events.'
  s.authors = { 'Tuomas Artman' => '@artman' }
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.homepage = 'https://github.com/artman/Signals'
 
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'Signals/*.swift'
  s.requires_arc = true
 
  s.source = { :git => 'https://github.com/artman/Signals.git', :branch => 'master' }
end
