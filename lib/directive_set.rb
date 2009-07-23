module MetaMark
  class DirectiveSet
    attr_accessor :layout, :children, :directives

    def initialize(layout)
      @directives = []
      @children   = []
      @layout     = layout

      @active_directive = Directive.new
    end

    def active_directive; @active_directive end

    def self.extract_from(layout)
      ds = DirectiveSet.new(layout)
      ds.layout.each do |line|
        directive = ds.active_directive
        if directive.open?
          if Directive.ends_on?(line) 
            directive.end_with(line) 
            ds.store_directive
          else
            directive.contents << line
          end
        else
          directive.open_with(line) if Directive.begins_on?(line)
          ds.store_directive if directive.closed?
        end
      end

      return ds if ds.has_directives?
    end

    def has_directives?
      not directives.empty?
    end

    def store_directive(directive=nil)
      directive  ||= active_directive

      directives <<  directive

      child      =   DirectiveSet.extract_from(directive.content) 
      children   <<  child if child 
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

