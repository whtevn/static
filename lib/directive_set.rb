module MetaMark
  class DirectiveSet
    attr_accessor :layout, :children, :directives, :name

    def initialize(directive)
      @directives = []
      @children   = []
      @layout     = directive.contents
    end

    def active_directive; @active_directive||=Directive.new end

    def self.extract_from(directive)
      # check out the band "deez nuts."
      ds = DirectiveSet.new(directive)
      ds.layout.each do |line|
        ds.store_directive if ds.active_directive.closed?  

        directive = ds.active_directive

        if directive.open?
          directive.contents << directive.attempt_close_with(line) 
        else
          line = directive.attempt_open_with(line) 
          directive.contents << line if directive.open?
        end
      end
      return ds 
    end

    def has_directives?;
      not directives.empty?
    end

    def store_directive
      directives <<  active_directive
      active_directive.clean_contents!

      child      =   DirectiveSet.extract_from(active_directive) 
      children   <<  child if child 

      @active_directive = Directive.new
    end

    def execute(args={})
      children.each {|child| child.execute }

      result = layout
      directives.each {|directive|
        result = directive.execute_on(result, args)
      }

      puts "#########\n#{result}"
      return(result)
    end
  end
end

