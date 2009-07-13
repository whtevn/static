require 'metamark'

`rm structure/*`

def separate_content_and_structure(layout)
  while MetaMark.blueprint_directives_remaining?(layout) 
    if directive = MetaMark.report_first_directive(layout)
      directive_range = (directive[:range].first+1..directive[:range].end-1) 
      separate_content_and_structure(MetaMark.print_chunk(layout, directive_range))
    end
    layout = run_directive(directive, layout) 
    File.open("structure/#{directive[:directive][:name]}_#{directive[:directive][:type]}", 'w') {|f| f.write(layout) } if directive
    puts layout
  end
end

def run_directive(instruction, layout)
  if instruction
    text_directive = MetaMark.write_directive(instruction[:directive].merge({:command => "print"}))
    MetaMark.insert_text(layout, instruction[:range], text_directive) 
  end
end

file = File.new("blueprint.html", "r")
layout = ""
file.each {|l| layout << l}
separate_content_and_structure(layout)
