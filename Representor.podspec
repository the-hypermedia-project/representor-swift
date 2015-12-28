Pod::Spec.new do |spec|
  spec.name = 'Representor'
  spec.version = '0.7.0'
  spec.summary = 'A canonical resource object interface in Swift.'
  spec.homepage = 'https://github.com/the-hypermedia-project/representor-swift'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'kyle@fuller.li' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/the-hypermedia-project/representor-swift.git', :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'
  spec.watchos.deployment_target = '2.0'
  spec.source_files = 'Representor/*.{swift,h}'
end
