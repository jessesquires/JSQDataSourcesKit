Pod::Spec.new do |s|
   s.name = 'JSQDataSourcesKit'
   s.version = '8.0.0'
   s.license = 'MIT'

   s.summary = 'Protocol-oriented, type-safe data source objects that keep your view controllers light'
   s.homepage = 'https://github.com/jessesquires/JSQDataSourcesKit'
   s.documentation_url = 'https://jessesquires.github.io/JSQDataSourcesKit/'

   s.social_media_url = 'https://twitter.com/jesse_squires'
   s.author = 'Jesse Squires'

   s.source = { :git => 'https://github.com/jessesquires/JSQDataSourcesKit.git', :tag => s.version }
   s.source_files = 'Source/*.swift'

   s.swift_version = '4.2'
   s.ios.deployment_target = '11.0'
   s.tvos.deployment_target = '11.0'

   s.frameworks = 'CoreData'
   s.requires_arc = true
end
