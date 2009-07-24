module MetaMark
  class Directive
    attr_accessor :open, :contents, :close

    def initialize
      @contents=""
    end

    def self.beginning?(line)
      test = Command.delimit(line)
      test and test.command != "end"
    end

    def self.ending?(line)
      test = Command.delimit(line)
      test and test.command == "end"
    end

    def attempt_open_with(line)
      if Directive.beginning?(line)
        self.open = Command.delimit(line)
        line = line.sub(/.*<!--/, '<!--')
      end
      line ||= ""
    end

    def attempt_close_with(line)
      if Directive.ending?(line) 
        self.close = Command.delimit(line)
        line = line.sub(/-->.*/, '-->')
      end
      line ||= ""
    end

    def clean_contents
      contents.sub(/<!--.*(.*).*-->/, '').reverse.sub(/>--.*dne.*--!</, '').reverse
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
