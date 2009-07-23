module MetaMark
  class Directive
    attr_accessor :command, :name, :type, :definition, :args, :open, :close, :children

    def self.create(definition)
        command    = definition.split("(")
        definition = {:command => command[0].metamark_clean, :definition => definition}
        command    = command[1].split(",").collect {|a| a = a.metamark_clean }
        Directive.new({:name => command[0],
                       :type =>command[1],
                       :args =>command[2]}.merge(definition))
    end

    def initialize(args={})
      @args       = args[:args]
      @name       = args[:name]
      @type       = args[:type]
      @command    = args[:command]
      @definition = args[:definition]
      @children   = []
    end

    def arg_string
      "#{self.name}, :#{self.type}#{", :#{self.args}" if self.args}"
    end

    def print(as_end=false)
      "<!--%% #{self.command}(#{self.arg_string}) #{"%%" if as_end}-->" 
    end

  end
end