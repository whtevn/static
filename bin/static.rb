require 'metamark'
require 'directive'

dir = "frank" #ARGV[0]

`rm structure/*`

ENV={}

ENV['project_base'] = File.dirname(dir)

ENV['content']      = File.join(ENV['project_base'], "content")
ENV['structure']    = File.join(ENV['project_base'], "structure")
ENV['blueprints']   = File.join(ENV['project_base'], "bluprints")
ENV['images']       = File.join(ENV['blueprints']  , "images")
ENV['stylesheets']  = File.join(ENV['blueprints']  , "stylesheets")
ENV['javascripts']  = File.join(ENV['blueprints']  , "javascripts")
ENV['resources']    = File.join(ENV['blueprints']  ,  "resources")

def separate_content_and_structure(layout)
  while MetaMark.directives_remaining?(layout, :use_as, :use) 
    if directive = MetaMark.report_first_directive(layout)
      separate_content_and_structure(directive.content)
    end
    if directive
      layout = directive.content
      File.open("structure/#{directive.name}_#{directive.type}", 'w') {|f| f.write(layout) } 
    end
  end
  return layout
end

file = File.new("blueprint.html", "r")
layout = ""
file.each {|l| layout << l}
separate_content_and_structure(layout)
