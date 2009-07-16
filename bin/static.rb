require 'metamark'

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

  while MetaMark.blueprint_directives_remaining?(layout) 
    if directive = MetaMark.report_first_directive(layout)
      separate_content_and_structure(directive[:content])
    end
    layout = run_directive(directive, layout) 
    File.open("structure/#{directive[:name]}_#{directive[:type]}", 'w') {|f| f.write(layout) } if directive
  end
end

def run_directive(instruction, layout)
  if instruction
    text_directive = MetaMark.write_directive(instruction.merge({:command => "print"}))
    puts layout
    puts "################"
    layout.sub!(instruction[:content], text_directive)
  end
end

file = File.new("blueprint.html", "r")
layout = ""
file.each {|l| layout << l}
separate_content_and_structure(layout)
