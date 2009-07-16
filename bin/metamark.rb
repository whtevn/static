class String
  def metamark_clean
    self.sub(":", '').sub(")", '').sub("-->",'').gsub("%",'').sub("<!--", '').gsub(",","").strip
  end
end

module MetaMark
  class<<self
    def report_first_directive(text)
      content = ""
      directive = nil
      text.each_with_index {|line, i|
        if not directive
          directive = gather_directive(line) 
          line = line.sub(/^.*<!--.*%%.*-->/, '')
        end

        if directive
          directive[:content] ||= ""
          if directive_over?(directive, line)
            directive[:content] << line.sub(/<!--.*%%.*-->.*$/, '')
            return directive
          else
            directive[:content] << line
          end 
        end
      }
      
      return nil if not directive
    end

    def gather_directive(line)
      if line =~ /<!--.*%%.*-->/
        command = line.split("(")
        val = {:command => command[0].metamark_clean}
        command = command[1].split(",").collect {|a| a = a.metamark_clean }
        {:name => command[0], :type =>command[1], :args =>command[2]}.merge(val)
      end
    end

    def directive_over?(directive, line)
      end_directive = gather_directive(line)
      return nil unless directive and end_directive

      if end_directive[:command] == "end"
        directive.reject {|k, v| k==:command || k==:content} == end_directive.reject{|k,v| k==:command || k==:content}
      end
    end

    def blueprint_directives_remaining?(text)
      return false if not text
      text.each do |line|
        directive = gather_directive(line)
        return true if directive and directive[:command] =~ /use/
      end
    end

    def write_directive(directive)
      "<!--%% #{directive[:command]}(:#{directive[:name]}, :#{directive[:type]}, :#{directive[:args]}) -->" 
    end
  end
end

__END__

describe MetaMark do
  before do
    @sample_text = File.new("blueprint.html", "r")
    @sub_text = "<div>this is some honkey business!</div>
<p>
  <!--%% use_as(:main, :content, :for => \"partials/outside\") -->
  this is some major honkey business....
  <!--%% end(:main, :content, :for => \"partials/outside\") -->
</p>
"

  end
  it "should report the line numbers of the first use_as / end chunk as a range" do
    MetaMark.report_first_directive(@sample_text)[:range].should == (3..8)
  end

  it "should be able to print out a set of line numbers to another file" do
    MetaMark.print_chunk(@sample_text, (3..8)).should == @sub_text
  end

  it "should be able to substitute some text over a set of line numbers" do
  end

  it "should be able to report there are no chunks left" do
  end
end
  
__END__
