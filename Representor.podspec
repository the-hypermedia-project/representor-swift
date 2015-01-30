Pod::Spec.new do |spec|
  spec.name = 'Representor'
  spec.version = '0.1.0'
  spec.summary = 'A canonical resource object interface in Swift.'
  spec.homepage = 'https://github.com/the-hypermedia-project/representor-swift'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'inbox@kylefuller.co.uk' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/the-hypermedia-project/representor-swift.git', :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.subspec 'Core' do |core_spec|
    core_spec.source_files = 'Representor/*.{swift,h}', 'Representor/Builder/*.swift'
  end

  spec.subspec 'HTTP' do |http_spec|
    http_spec.subspec 'Core' do |core_spec|
      core_spec.dependency 'Representor/Core'
      core_spec.dependency 'Representor/Adapter/HAL'
      core_spec.source_files = 'Representor/HTTP/*.swift', 'Representor/HTTP/Adapters/*.swift'
    end

    http_spec.subspec 'APIBlueprint' do |blueprint_spec|
      blueprint_spec.dependency 'Representor/Core'
      blueprint_spec.dependency 'Representor/HTTP/Core'
      blueprint_spec.source_files = 'Representor/HTTP/APIBlueprint/*.swift'
    end
  end

  spec.subspec 'Adapter' do |adapter_spec|
    adapter_spec.subspec 'HAL' do |hal_spec|
      hal_spec.dependency 'Representor/Core'
      hal_spec.source_files = 'Representor/Adapters/HALAdapter.swift'
    end
  end
end

