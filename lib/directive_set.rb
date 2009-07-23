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
        directive = ds.active_directive

        ds.store_directive if directive.closed?  

        if directive.open?
          if Directive.ends_on?(line) 
            directive.end_with(line) 
          else
            directive.contents << line
          end
        else
          directive.open_with(line) if Directive.begins_on?(line)
        end
      end

      return ds if ds.has_directives?
    end

    def has_directives?
      not directives.empty?
    end

    def store_directive
      directives <<  active_directive

      child      =   DirectiveSet.extract_from(active_directive.content) 
      children   <<  child if child 

      @active_directive = Directive.new
    end
  end
end

