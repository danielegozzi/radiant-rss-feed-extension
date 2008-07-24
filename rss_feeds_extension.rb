require_dependency 'application'

class RssFeedsExtension < Radiant::Extension
  version "1.0"
  description "An extension that serves Radiant pages in RSS feeds."
  url ""
  
  define_routes do |map|
    map.rss 'rss/*url.xml', :controller => 'rss', :action => 'index', :format => 'xml'
    map.rss 'rss/*url', :controller => 'rss', :action => 'index', :format => 'html'
  end
  
  def activate

  end
  
  def deactivate

  end
end
