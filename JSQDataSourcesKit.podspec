Pod::Spec.new do |s|
   s.name = 'JSQDataSourcesKit'
   s.version = '1.0.0'
   s.license = 'MIT'

   s.summary = 'Type-safe, value-oriented data source objects that keep your view controllers light'
   s.homepage = 'https://github.com/jessesquires/JSQDataSourcesKit'
   s.documentation_url = 'http://jessesquires.com/JSQDataSourcesKit'

   s.social_media_url = 'https://twitter.com/jesse_squires'
   s.authors = { 'Jesse Squires' => 'jesse.squires.developer@gmail.com' }

   s.source = { :git => 'https://github.com/jessesquires/JSQDataSourcesKit.git', :tag => s.version }
   s.source_files = 'JSQDataSourcesKit/JSQDataSourcesKit/*.swift'
   s.resources = 'JSQDataSourcesKit/JSQDataSourcesKit/*.xib'

   s.platform = :ios, '8.0'
   s.frameworks = 'Foundation', 'UIKit', 'CoreData'
   s.requires_arc = true
end
