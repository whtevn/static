module MetaMark
  class Command
    attr_accessor :command, :name, :type, :definition, :args

    def self.delimit(definition)
      return nil unless definition =~ /<!--.*%%.*-->/
      command    = definition.split("(")
      definition = {:command => command[0].metamark_clean, :definition => definition}
      command    = command[1].split(",").collect {|a| a = a.metamark_clean }
      Command.new({:name => command[0],
                   :type =>command[1],
                   :args =>command[2]}.merge(definition))
    end

    def clone_as(new_command)
      Command.new({:args => args,
                   :definition => definition,
                   :type => type,
                   :name => name,
                   :command => new_command})
    end

    def initialize(args={})
      @args       = args[:args]
      @name       = args[:name]
      @type       = args[:type]
      @command    = args[:command]
      @definition = args[:definition]
    end

    def arg_string
      "#{self.name}, :#{self.type}#{", :#{self.args}" if self.args}"
    end

    def print(as_end=false)
      "<!--%% #{self.command}(#{self.arg_string}) #{"%%" if as_end}-->" 
    end
  end
end

