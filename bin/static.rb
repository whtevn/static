require 'yaml'

require 'lib/command'
require 'lib/directive'
require 'lib/directive_set'

include MetaMark

dir = File.join(File.basename(__FILE__), '..', 'example')#ARGV[0]

ENV['project_base'] = File.expand_path(dir)

ENV['layout']       = File.join(ENV['project_base'], 'layout')
ENV['content']      = File.join(ENV['project_base'], 'content')
ENV['structure']    = File.join(ENV['project_base'], 'structure')

ENV['images']       = File.join(ENV['layout'], 'images')
ENV['stylesheets']  = File.join(ENV['layout'], 'stylesheets')
ENV['javascripts']  = File.join(ENV['layout'], 'javascripts')
ENV['resources']    = File.join(ENV['layout'],  'resources')

class String
  def metamark_clean
    self.sub(':', '').sub(')', '').sub('-->','').gsub('%','').sub('<!--', '').gsub(',','').strip
  end
end

layout = ""
file = File.open(File.join(ENV['layout'], 'base.html'), 'r')
file.each {|l| layout << l }

primary_directive = Directive.new
primary_directive.contents = layout
primary_directive.open = Command.new(:name => "base",
                                     :type => "layout")

DirectiveSet.extract_from(primary_directive, :layout).execute

__END__
site_info = nil
File.open(File.join(ENV['layout'], 'base.html')){|file|
 site_info = YAML::load(file)
}


  def gather_pages(page=nil, first_time=true, parent=nil)
    index = nil
    if first_time
      reset_location
      @pages = []
      page ||= map
    else
      index = true if @pages.empty?
    end
    case page
    when String : pages << Page.new(page, home, location, site_loc, parent, index)
    when Array then
      tmp = page.dup
      gather_pages(tmp.shift, false, parent) while(tmp.size > 0)
    when Hash then
      page.each { |page_name, sub_pages|
        unless first_time 
          set_location(pages.empty? ? location : location+page_name )
          pages << Page.new(page_name, home, location, site_loc, sub_pages, index) 
        else
          page_name = nil
        end
        gather_pages(sub_pages, false, page_name)
        set_location location.sub(page_name.as_file+'/', '') if page_name
      }
    else
      return nil
    end
  end

  def make_breadcrumbs
    pages.each do |page|
      page.breadcrumbs << page.name.as_file
      page.subs.each { |p|
        if p.kind_of?(Hash)
          p.each{ |k, v|
            tmp = Page.find(k)
            tmp.breadcrumbs << page.breadcrumbs }
        else
          tmp = Page.find(p).breadcrumbs << page.breadcrumbs  
        end
      } if page.has_subs? && page.subs.kind_of?(Array)
      page.breadcrumbs.flatten!
    end
  end
