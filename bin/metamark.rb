class String
  def metamark_clean
    self.sub(":", '').sub(")", '').sub("-->",'').gsub("%",'').sub("<!--", '').gsub(",","").strip
  end
end

module MetaMark
  class<<self
    def report_first_directive(text)
      content = ""
      directive = nil
      text.each_with_index {|line, i|
        if not directive
          if directive = gather_directive(line) 
            directive.open = line.match(/<!--.*%%.*-->/).to_s
            line = line.sub(/^.*<!--.*%%.*-->/, '')
          end
        end

        if directive
          directive.content ||= ""
          if directive_over?(directive, line)
            directive.close = line.match(/<!--.*%%.*-->/).to_s
            directive.content << line.sub(/<!--.*%%.*-->.*$/, '')
            return directive
          else
            directive.content << line
          end 
        end
      }
      
      return nil if not directive
    end

    def gather_directive(line)
      if line =~ /<!--.*%%.*-->/
        command = line.split("(")
        val = {:command => command[0].metamark_clean}
        command = command[1].split(",").collect {|a| a = a.metamark_clean }
        Directive.new({:name => command[0], :type =>command[1], :args =>command[2]}.merge(val))
      end
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
