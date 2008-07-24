xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    site_root = @page.ancestors.find{|p| p.parts.find_by_name('section_title')} || Page.root
    xml.title(@page.title + ' @ ' + site_root.title)
    xml.link(@page.url)
    xml.description(@page.title + ' @ ' + site_root.title)
    xml.language(@page.language)
      for child in @pages
        xml.item do
          xml.title(child.title)
          xml.description(child.render_part(:body))      
          xml.author((child.created_by.blank? ? "" : child.created_by.name) || "")               
          xml.pubDate(child.published_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          xml.link(child.url)
          xml.guid(child.url)
        end
      end
  }
}
