## methodhash.gemspec
#

Gem::Specification::new do |spec|
  spec.name = "methodhash"
  spec.description = 'A Hash for automatic storage of values obtained from a method defined by the user.' 
  spec.version = "0.5.0"
  spec.platform = Gem::Platform::RUBY
  spec.summary = 'methodhash'

  spec.files = ["methodhash.gemspec", "lib", "lib/methodhash.rb", "README", "samples", "samples/samples.rb"]
  spec.executables = []
  
  spec.require_path = "lib"

  spec.has_rdoc = true

  spec.extensions.push(*[])

  spec.rubyforge_project = "methodhash"
  spec.author = "Fredrik Johansson"
  spec.email = "fredjoha@gmail.com"
  spec.homepage = "http://github.com/fredrikj/methodhash/tree/master"
end
