# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

target 'AntBusDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AntBusDemo

  pod 'AntBus', :path => 'AntBus'
  pod 'LoginModule', :path => 'Others/LoginModule'
#  pod 'BaseModule', :path => 'Common/BaseModule'
  pod 'CommonModule', :path => 'Common/CommonModule'
  
#  target 'HAHATests' do
#    inherit! :search_paths
#    # Pods for testing
#  end

  target 'AntBusDemoTests' do
    # Pods for testing
    inherit! :search_paths
    pod 'AntBus', :path => 'AntBus'
    pod 'CommonModule', :path => 'Common/CommonModule'
  end
  
  target 'AntBusDemoUITests' do
    # Pods for testing
    pod 'AntBus', :path => 'AntBus'
  end
  
end
