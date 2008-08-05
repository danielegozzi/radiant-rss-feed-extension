xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", :'xmlns:atom' => "http://www.w3.org/2005/Atom"){
  xml.channel{
    xml.title{xml.cdata!(feed_title(@pages))}
    xml.link{xml.cdata!(feed_url(@pages))}
    xml.description{xml.cdata!(strip_tags(to_description(@pages)))}
    xml.language {xml.cdata!("en-us")}
    xml.tag!("atom:link", :href => URI::escape(request.url), :rel => "self", :type => "application/rss+xml")
      for item in @items
        xml.item do
          xml.title{xml.cdata!(item.title)}
          xml.description do
            xml.cdata!(h(item.render_part(:body)))
          end
          xml.pubDate(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link{xml.cdata!(to_absolute_url(item.url))}
          xml.guid{xml.cdata!(to_absolute_url(item.url))}
        end
      end
  }
}
