
# WARNING: Nothing but load/autoload should be in this file.

[
  "hacks/**/*.rb",
].each do |fmask|
  Dir[File.expand_path("../#{fmask}", __FILE__)].each do |fn|
    require fn
  end
end
