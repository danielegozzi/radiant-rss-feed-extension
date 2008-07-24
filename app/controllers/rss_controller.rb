class RssController < ApplicationController
  no_login_required

  CACHE_DIR = File.join(RAILS_ROOT, 'rss_cache')

  def initialize
    FileUtils.mkdir_p(CACHE_DIR)
    @cache = ResponseCache.new(:directory => CACHE_DIR)
  end

  attr_accessor :cache

  def index
    unless params[:url].blank?
      url = params[:url].join('/')
    else
      url = '/'
    end
    if params[:keywords].blank?
      keywords = []
      keywords_url = url
    else
      keywords = params[:keywords].map(&:strip)
      keywords_url = [url, 'keywords', keywords.sort].flatten.join('/')
    end
    params[:format] ||= 'html'
    respond_to do |format|
      format.html do
        to = '/' + params[:url].map{|part| CGI::escape(part)}.join('/')
        to_page = Page.find_by_url(to)
        if ! (to_page.blank? || to_page.headers.values.any?{|v| v =~ /\A404 /})
          redirect_to to
        else
          redirect_to '/'
        end
      end
      format.xml do
        response.headers["Content-Type"] = "application/rss+xml; charset=utf-8"
        response.headers.delete('Cache-Control')
        @page = Page.find_by_url(url)
        if keywords.empty?
          @pages = @page.children.find(:all, :conditions => 'class_name IS NULL', :order => "published_at DESC")
        else
          conditions = ['class_name IS NULL AND (' + keywords.map{|k| "keywords LIKE ?"}.join(' OR ') + ')', keywords.map{|k| "%#{k}%"}].flatten
          @pages = []
          offset = 0
          loop do
            children = @page.children.find(:all, :conditions => conditions, :order => 'published_at DESC', :limit => 30, :offset => offset)
            found_children = children.length
            children.delete_if do |child|
              (child.keywords.split(',').map(&:strip) & keywords).empty?
            end
            @pages += children
            offset += 30
            break if found_children < 30 || @pages.length >= 30
          end
          @pages.slice!(30)
        end
        if (request.get? || request.head?) and (@cache.response_cached?(keywords_url))
          @cache.update_response(keywords_url, response, request)
        else
          @cache.cache_response(keywords_url, response) if request.get?
        end
      end  
    end
  end
end
