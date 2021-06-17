Pod::Spec.new do |s|
    s.name             = 'DHash'
    s.version          = '1.0.0'
    s.summary          = 'DHashes can be used to quickly check if images are kind-of similar'
    s.homepage         = 'https://github.com/AndreasVerhoeven/DHash'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Andreas Verhoeven' => 'cocoapods@aveapps.com' }
    s.source           = { :git => 'https://github.com/AndreasVerhoeven/DHash.git', :tag => s.version.to_s }
    s.module_name      = 'DHash'

    s.swift_versions = ['5.0']
    s.ios.deployment_target = '11.0'
    s.source_files = 'Sources/*.swift'
end
