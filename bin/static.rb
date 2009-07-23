require 'lib/command'
require 'lib/directive'
require 'lib/directive_set'

include MetaMark

dir = File.join(File.basename(__FILE__), '..', 'example')#ARGV[0]

ENV['project_base'] = File.expand_path(dir)

ENV['layout']       = File.join(ENV['project_base'], 'layout')

ENV['content']      = File.join(ENV['project_base'], 'content')
ENV['structure']    = File.join(ENV['project_base'], 'structure')

ENV['images']       = File.join(ENV['layout'], 'images')
ENV['stylesheets']  = File.join(ENV['layout'], 'stylesheets')
ENV['javascripts']  = File.join(ENV['layout'], 'javascripts')
ENV['resources']    = File.join(ENV['layout'],  'resources')

class String
  def metamark_clean
    self.sub(':', '').sub(')', '').sub('-->','').gsub('%','').sub('<!--', '').gsub(',','').strip
  end
end

File.open(File.join(ENV['layout'], 'base.html')){|file|
 DirectiveSet.extract_from(file)
}

