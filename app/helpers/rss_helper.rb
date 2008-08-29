module RssHelper
  def breadcrumbs(page, separator = " > ")
    breadcrumbs = [page.breadcrumb]
    page.ancestors.each do |ancestor|
      breadcrumbs.unshift ancestor.breadcrumb
    end
    breadcrumbs.join(separator)
  end

  def feed_url(pages)
    pages ||= []
    if pages.length == 1
      to_absolute_url(pages.first.url)
    else
      to_absolute_url('/')
    end
  end

  def feed_title(pages)
    parents = []
    titles = []
    pages ||= []
    for page in pages
      if page.parent.nil?
        parents << page
        pages.delete(page)
      else
        parents << page.parent
      end
    end
    parents.uniq!
    for parent in parents
      title = parent.title
      children = pages.find_all{|page| page.parent == parent}
      if ! children.empty?
        title += ' > ' + children.map(&:title).join(' & ')
      end
      titles << title
    end
    titles.join('; ')
  end

  def to_description(pages)
    if pages.length > 1
      pages.map{|page| breadcrumbs(page)}.join("; ")
    elsif pages.length == 1
      breadcrumbs(pages.first)
    else
      ""
    end
  end

  def to_absolute_url(url)
    url_for :controller => 'site', :action => 'show_page', :only_path=> false, :url => url.gsub(/\A\//,'')
  end
end
