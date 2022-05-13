
Pod::Spec.new do |s|
  s.name             = 'AntBus'
  s.version          = '1.3.1'
  s.summary          = 'AntBus'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/abiaoyo/AntBus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '347991555@qq.com' => '347991555@qq.com' }
  s.source           = { :git => 'https://github.com/abiaoyo/AntBus.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.swift_version = '5.0'
  
  s.default_subspecs = 'ForSwift'

  s.subspec 'ForSwift' do |ss|
    ss.source_files         = 'AntBus/AntBus/Classes/ForSwift/*'
  end

  s.subspec 'ForOC' do |ss|
    ss.dependency 'AntBus/ForSwift'
    ss.source_files         = 'AntBus/AntBus/Classes/ForOC/*'
  end
  
end
