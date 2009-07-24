module MetaMark
  class DirectiveSet
    attr_accessor :layout, :children, :directives

    def initialize(layout)
      @directives = []
      @children   = []
      @layout     = layout
    end

    def active_directive; @active_directive||=Directive.new end

    def self.extract_from(layout)
      ds = DirectiveSet.new(layout)
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

    def has_directives?
      not directives.empty?
    end

    def store_directive
      directives <<  active_directive

      child      =   DirectiveSet.extract_from(active_directive.clean_contents) 
      children   <<  child if child 

      @active_directive = Directive.new
    end

    def execute(args={})
      children.each {|child| child.execute }

      result = layout
      directives.each {|directive|
        result = directive.execute_on(result, args)
      }
      return(result)
    end
  end
end

