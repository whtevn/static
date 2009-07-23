module MetaMark
  class Directive
    attr_accessor :open, :contents, :close

    def initialize
      @contents=""
    end

    def self.begining?(line)
      test = Command.delimit(line)
      test and test.command != "end"
    end

    def self.ending?(line)
      test = Command.delimit(line)
      test and test.command == "end"
    end

    def open_with(line)
      self.open = Command.delimit(line)
    end

    def close_with(line)
      test = Command.delimit(line)
      self.close = test if test and self.end_match?(test)
    end

    def open?
      open and open.kind_of?(Command) and open.command != "end"
    end

    def closed?
      open and 
      open.definition =~ /<!--.*%%.*%%.*-->/ or
      (close and close.kind_of?(Command) and end_match?)
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
