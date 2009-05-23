require 'fileutils'
configFile = File.dirname(__FILE__) + '/../../../config/pygmy_mailchimp.yml'
FileUtils.cp File.dirname(__FILE__) + '/pygmy_mailchimp.yml.tpl', configFile unless File.exist?(configFile)
puts IO.read(File.join(File.dirname(__FILE__), 'README'))