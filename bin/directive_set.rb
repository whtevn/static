module MetaMark
  class DirectiveSet
    attr_accessor :open, :content, :close, :layout

    def print
      tag = open.print(self.has_content?)
      if self.content
        tag += self.content 
        tag += close.print
      end
      return tag
    end

    def closed?
      open.definition =~ /^.*<!--.*%%.*%%.*-->/ or close.kind_of?(Directive)
    end

    def end_match?(directive)
      directive.command == "end"  and
      directive.name == open.name and
      directive.type == open.type and
      directive.args == open.args 
    end
  end
end

