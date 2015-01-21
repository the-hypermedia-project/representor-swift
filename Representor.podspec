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
  spec.ios.deployment_target = '7.0'
  spec.osx.deployment_target = '10.9'

  spec.subspec 'Core' do |core_spec|
    core_spec.source_files = 'Representor/*.{swift,h}'
  end

  spec.subspec 'Builder' do |builder_spec|
    builder_spec.dependency 'Representor/Core'
    builder_spec.source_files = 'Representor/Builder/*.swift'
  end

  spec.subspec 'Adapter' do |adapter_spec|
    adapter_spec.subspec 'Response' do |response_spec|
      response_spec.dependency 'Representor/Adapter/HAL'
      response_spec.dependency 'Representor/Adapter/Siren'
      response_spec.dependency 'WebLinking'
      response_spec.source_files = 'Representor/Adapters/NSHTTPURLResponseAdapter.swift'
    end

    adapter_spec.subspec 'HAL' do |hal_spec|
      hal_spec.dependency 'Representor/Core'
      hal_spec.source_files = 'Representor/Adapters/HALAdapter.swift'
    end

    adapter_spec.subspec 'Siren' do |siren_spec|
      siren_spec.dependency 'Representor/Core'
      siren_spec.source_files = 'Representor/Adapters/SirenAdapter.swift'
    end
  end
end

