class RssController < ApplicationController
  no_login_required

  CACHE_DIR = File.join(RAILS_ROOT, 'rss_cache')

  def initialize
    FileUtils.mkdir_p(CACHE_DIR)
    @cache = ResponseCache.new(:directory => CACHE_DIR)
  end

  attr_accessor :cache

  def index
    if ! params[:url].blank?
      urls = [params[:url]]
    elsif (! params[:urls].blank?)
      urls = params[:urls]
    else
      urls = ['/']
    end
    urls.sort!
    if params[:keywords].blank?
      keywords = []
      keywords_url = urls.join('/other_page/').gsub(/\/+/, '/')
    else
      keywords = params[:keywords].map(&:strip)
      keywords_url = [urls, 'keywords', keywords.sort].flatten.join('/')
    end
    params[:format] ||= 'html'
    respond_to do |format|
      format.html do
        redirect_to '/'
      end
      format.xml do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        response.headers.delete('Cache-Control')
        @pages = urls.map{|url| Page.find_by_url(url)}.compact
        @pages.delete_if {|page| ! (page.headers['Status'] =~ /\A404 /).nil?}
        ids = @pages.map(&:id)
        @items = []
        return if ids.empty?
        conditions = ["(class_name IS NULL OR class_name = 'Page') AND parent_id IN (#{ids.join(',')})"]
        if ! keywords.empty?
          keywords_expr = '(' + keywords.map{|k| "keywords LIKE ?"}.join(' OR ') + ')'
          conditions[0] += " AND #{keywords_expr}"
          conditions += keywords.map{|k| "%#{k}%"}
        end
        offset = 0
        loop do
          children = Page.find(:all, :conditions => conditions, :order => 'published_at DESC', :limit => 30, :offset => offset)
          found_children = children.length
          if ! keywords.empty?
            children.delete_if do |child|
              (child.keywords.split(',').map(&:strip) & keywords).empty?
            end
          end
          @items += children
          offset += 30
          break if found_children < 30 || @items.length >= 30
        end
        @items.slice!(30)
      end
      if (request.get? || request.head?) and (@cache.response_cached?(keywords_url))
        @cache.update_response(keywords_url, response, request)
      else
        @cache.cache_response(keywords_url, response) if request.get?
      end
    end  
  end
end
