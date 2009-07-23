module MetaMark
  class Directive
    attr_accessor :open, :content, :close

    def self.begins_on?(line)
      line =~ /<!--.*%%.*-->/ and not line =~ /end(.*)/
    end

    def self.ends_on?(line)
      line =~ /<!--.*%%.*%%.*-->/ or line =~ /<!--.*%%.*-->/ and line =~ /end(.*)/
    end

    def open_with(line)
      open = Command.delimit(line)
    end

    def end_with(line)
      close = Command.delimit(line)
    end

    def open?
      open and open.kind_of?(Command) and open.command != "end"
    end

    def closed?
      open.definition =~ /<!--.*%%.*%%.*-->/ or (close.kind_of?(Command) and end_match?)
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
