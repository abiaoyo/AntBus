
Pod::Spec.new do |s|
  s.name             = 'AntBus'
  s.version          = '0.3.1'
  s.summary          = 'A short description of AntBus.'


  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/abiaoyo/AntBus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '347991555@qq.com' => '347991555@qq.com' }
  s.source           = { :git => 'https://github.com/abiaoyo/AntBus.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.source_files = 'AntBus/AntBus/Classes/*'
end
