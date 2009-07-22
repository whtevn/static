module MetaMark
  class DirectiveSet
    attr_accessor :open, :content, :close, :layout

    def self.start(definition=nil)
      return nil unless definition
      DirectiveSet.new(:open => definition.kind_of?(Directive) ?
                                  definition :
                                  Directive.create(definition))
    end

    def initialize(args={})
      @open = args[:open]
    end

    def self.extract_from(layout)
      puts "here"
      while MetaMark.directives_remaining?(layout, :use_as, :use) 
      puts "further"
        if directive = MetaMark.report_first_directive(layout)
      puts "holy scheikeis"
          self.extract_from(directive.content)
        end
        if directive
          layout = directive.content
          File.open("structure/#{directive.open.name}_#{directive.open.type}", 'w') {|f| f.write(layout) } 
        end
      end
      return layout
    end

    def print
      tag = open.print(self.has_content?)
      if self.content
        tag += self.content 
        tag += close.print
      end
      return tag
    end

    def started?
      open and open.kind_of?(Directive)
    end

    def closed?
      open.definition =~ /^.*<!--.*%%.*%%.*-->/ or (close.kind_of?(Directive) and end_match?)
    end

    def end_match?(directive=nil)
      directive ||= close
      directive.command == "end"  and
      directive.name == open.name and
      directive.type == open.type and
      directive.args == open.args 
    end
  end
end

