Pod::Spec.new do |s|
  s.name = 'Entish'
  s.version = '0.0.1'
  s.license = 'WTFPL'
  s.summary = 'Functional programming experiments and tools (in Swift).'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/Entish'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'src/*.swift', 'src/**/*.swift'
  s.requires_arc = true

  s.dependency 'LlamaKit'

  s.source = { :git => 'https://github.com/brynbellomy/Entish.git', :tag => s.version }
end
