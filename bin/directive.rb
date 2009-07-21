module MetaMark
  class Directive
    attr_accessor :command, :name, :type, :content, :args, :open, :close

    def initialize(args={})
      @args    = args[:args]
      @name    = args[:name]
      @type    = args[:type]
      @open    = args[:open]
      @close   = args[:close]
      @command = args[:command]
      @content = args[:content]
    end

    def self.print(directive)
      directive.print
    end

    def arg_string
      "#{self.name}, :#{self.type}#{", :#{self.args}" if self.args}"
    end

    def print
      tag = "<!--%% #{self.command}(#{self.arg_string}) -->" 
      if self.content
        tag += self.content 
        tag += "<!--%% end(#{self.arg_string}) -->"
      end
      return tag
    end

    def end_match?(directive)
      directive.command == "end"  and
      directive.name == self.name and
      directive.type == self.type and
      directive.args == self.args 
    end
  end
end
