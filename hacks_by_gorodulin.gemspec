Gem::Specification.new do |s|
  s.name = "hacks_by_gorodulin"
  s.version = "0.1.0"
  s.authors = ["Vladimir Gorodulin"]
  s.email = ["box@4letters.ru"]
  s.homepage = "http://github.com/gorodulin/hacks_by_gorodulin"

  # Copy these from class's description, adjust markup.
  s.summary = %q{My HackTree hacks}
  s.description = %q{My HackTree hacks}
  # end of s.description=

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map {|f| File.basename(f)}
  s.require_paths = ["lib"]

  s.add_dependency "hack_tree"
end
