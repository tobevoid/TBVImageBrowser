Pod::Spec.new do |s|
  s.name = 'TBVImageBrowser'
  s.version = '1.0.0'
  s.summary = 'A image browser which has strong extendibility.'
  s.homepage = 'https://github.com/tobevoid/TBVImageBrowser'
  s.documentation_url = 'https://github.com/tobevoid/TBVImageBrowser'

  s.license =  { :type => 'MIT' }
  s.authors = 'tripleCC'
  s.source = {
    :git => 'https://github.com/tobevoid/TBVImageBrowser.git',
    :tag => s.version.to_s,
  }

  s.source_files = 'TBVImageBrowser/TBVImageBrowser/**/*'

  s.ios.deployment_target     = "8.0"

  s.dependency 'ReactiveObjC', '~> 3.0'
  s.dependency 'TBVLogger', '~> 1.0'
end
