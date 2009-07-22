module MetaMark
  class<<self
    def report_first_directive(text)
      content = ""
      directive = DirectiveSet.new
      text.each {|line|
        if directive.started?
          directive.close = gather_directive(line) unless directive.closed?
          if directive.closed?  
            return directive
          else
            directive.content ||=""
            directive.content << line
          end
        else
          directive.open = gather_directive(line)
        end
      }
      
      return nil if not directive
    end

    def gather_directive(line)
      Directive.create(line) if line =~ /<!--.*%%.*-->/
    end

    def directive_over?(directive, line)
      end_directive = gather_directive(line)
      directive.end_match?(end_directive) if directive and end_directive
    end

    def directives_remaining?(text, *commands)
      text ||= ""
      text.each do |line|
        directive = gather_directive(line)
        return true if (directive and commands.include?(directive.command.to_sym))
      end
      return false
    end

  end
end
