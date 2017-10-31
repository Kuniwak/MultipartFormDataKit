Pod::Spec.new do |s|
  s.name             = 'MultipartFormDataKit'
  s.version          = '1.0.0'
  s.summary          = 'multipart/form-data for Swift.'
  s.description      = <<-DESC
    multipart/form-data for Swift.
    You can communicate by using this module and URLSession or other HTTP libraries.
	DESC
  s.homepage         = 'https://github.com/Kuniwak/MultipartFormDataKit'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kuniwak' => 'orga.chem.job@gmail.com' }
  s.source           = { :git => 'https://github.com/Kuniwak/MultipartFormDataKit.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'Sources/**/*'
  s.frameworks = 'Foundation'
end
