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

    def clean_contents!
      self.contents = self.clean_contents
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

    def execute_on(layout, args={})
      layout.sub(self.contents, resolve_execution(args))
    end

    def resolve_execution(args={})
      # this method will be the one to execute the meat of directives
      # coming from html documents. 

      # a directive should do any file printing, copying, etc, first
      # and then it should return a string that is a resulting tag

      # right now, I am just going to print out a print tag and be done with it.
      open.clone_as("print").print(:as_end) unless open.type == "layout"
    end
  end
end
