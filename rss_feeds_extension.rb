require_dependency 'application'

class RssFeedsExtension < Radiant::Extension
  version "1.0"
  description "An extension that serves Radiant pages in RSS feeds."
  url ""
  
  define_routes do |map|
    map.rss 'rss.xml', :controller => 'rss', :action => 'index', :format => 'xml'
  end
  
  def activate

  end
  
  def deactivate

  end
end
