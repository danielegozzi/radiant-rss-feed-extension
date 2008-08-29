xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", :'xmlns:atom' => "http://www.w3.org/2005/Atom"){
  xml.channel{
<<<<<<< HEAD:app/views/rss/index.xml.builder
    xml.title feed_title(@pages)
    xml.link feed_url(@pages)
    xml.description strip_tags(to_description(@pages))
    xml.language "en-us"
    xml.tag!("atom:link", :href => URI::escape(request.url,Regexp.union(URI::REGEXP::UNSAFE, /[\[\]]/)), :rel => "self", :type => "application/rss+xml")
=======
    xml.title{xml.cdata!(feed_title(@pages))}
    xml.link{xml.cdata!(feed_url(@pages))}
    xml.description{xml.cdata!(strip_tags(to_description(@pages)))}
    xml.language {xml.cdata!("en-us")}
    xml.tag!("atom:link", :href => URI::escape(request.url), :rel => "self", :type => "application/rss+xml")
>>>>>>> 911f9b1240284e36882b2af11915f31958221534:app/views/rss/index.xml.builder
      for item in @items
        xml.item do
<<<<<<< HEAD:app/views/rss/index.xml.builder
          xml.title item.title
          xml.description item.render_part(:body)
=======
          xml.title{xml.cdata!(item.title)}
          xml.description do
            xml.cdata!(h(item.render_part(:body)))
          end
>>>>>>> 911f9b1240284e36882b2af11915f31958221534:app/views/rss/index.xml.builder
          xml.pubDate(item.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
<<<<<<< HEAD:app/views/rss/index.xml.builder
          xml.link to_absolute_url(item.url)
          xml.guid to_absolute_url(item.url)
=======
          xml.link{xml.cdata!(to_absolute_url(item.url))}
          xml.guid{xml.cdata!(to_absolute_url(item.url))}
>>>>>>> 911f9b1240284e36882b2af11915f31958221534:app/views/rss/index.xml.builder
        end
      end
  }
}
