xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", :'xmlns:atom' => "http://www.w3.org/2005/Atom"){
  xml.channel{
    xml.title feed_title(@pages)
    xml.link feed_url(@pages)
    xml.description strip_tags(to_description(@pages))
    xml.language "en-us"
    xml.tag!("atom:link", :href => URI::escape(request.url,Regexp.union(URI::REGEXP::UNSAFE, /[\[\]]/)), :rel => "self", :type => "application/rss+xml")
      for item in @items
        xml.item do
          xml.title item.title
          xml.description item.render_part(:body)
          xml.pubDate(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link to_absolute_url(item.url)
          xml.guid to_absolute_url(item.url)
        end
      end
  }
}
