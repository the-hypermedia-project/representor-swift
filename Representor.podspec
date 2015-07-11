Pod::Spec.new do |spec|
  spec.name = 'Representor'
  spec.version = '0.6.1'
  spec.summary = 'A canonical resource object interface in Swift.'
  spec.homepage = 'https://github.com/the-hypermedia-project/representor-swift'
  spec.license = { :type => 'MIT', :file => 'LICENSE' }
  spec.author = { 'Kyle Fuller' => 'kyle@fuller.li' }
  spec.social_media_url = 'http://twitter.com/kylefuller'
  spec.source = { :git => 'https://github.com/the-hypermedia-project/representor-swift.git', :tag => "#{spec.version}" }
  spec.requires_arc = true
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.9'

  spec.subspec 'Core' do |core_spec|
    core_spec.source_files = 'Representor/*.{swift,h}', 'Representor/Builder/*.swift'
  end

  spec.subspec 'HTTP' do |http_spec|
    http_spec.subspec 'Transition' do |transition_spec|
      transition_spec.dependency 'Representor/Core'
      transition_spec.source_files = 'Representor/HTTP/HTTPTransition{,Builder}.swift'
    end

    http_spec.subspec 'Deserialization' do |deserialization_spec|
      deserialization_spec.dependency 'Representor/HTTP/Transition'
      deserialization_spec.dependency 'Representor/HTTP/Adapters/HAL'
      deserialization_spec.dependency 'Representor/HTTP/Adapters/Siren'
      deserialization_spec.source_files = 'Representor/HTTP/HTTPDeserialization.swift'
    end

    http_spec.subspec 'Adapters' do |adapter_spec|
      adapter_spec.subspec 'HAL' do |hal_spec|
        hal_spec.dependency 'Representor/HTTP/Transition'
        hal_spec.source_files = 'Representor/HTTP/Adapters/HTTPHALAdapter.swift'
      end

      adapter_spec.subspec 'Siren' do |siren_spec|
        siren_spec.dependency 'Representor/HTTP/Transition'
        siren_spec.source_files = 'Representor/HTTP/Adapters/HTTPSirenAdapter.swift'
      end

      adapter_spec.subspec 'APIBlueprint' do |blueprint_spec|
        blueprint_spec.dependency 'Representor/HTTP/Transition'
        blueprint_spec.source_files = 'Representor/HTTP/APIBlueprint/*.swift'
      end
    end
  end
end

