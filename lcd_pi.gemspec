Gem::Specification.new do |s|
  s.name        = 'lcd_pi'
  s.version     = '0.0.1'
  s.license     = 'The MIT License (MIT)'
  s.date        = '2013-10-28'
  s.platform    = Gem::Platform::RUBY
  s.summary     = "HD44780 LCD library that works on top of WiringPi to integrate directly with a Raspberry Pi"
  s.authors     = "Geoff Evans"
  s.email       = 'gbeevans@gmail.com'
  s.files       = Dir.glob('lib/*.rb') + Dir.glob('ext/**/**/*.{c,h}') + Dir.glob('ext/**/*.{c,h,rb}')
  s.homepage    = 'http://rubygems.org/gems/wiringpi'
  
  s.add_runtime_dependency 'wiringpi'
  
  
  s.description = 'HD44780 LCD library that works on top of WiringPi to integrate directly with a Raspberry Pi. This is inspired on the work of RobvanB https://github.com/RobvanB/Ruby-RaspberryPi-LCD.'
end