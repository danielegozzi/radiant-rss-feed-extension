require File.dirname(__FILE__) + '/../spec_helper'

describe RssController do
  scenario :pages

  it "should redirect to an existent page when called without .xml" do
    get 'index', :url => ['parent']
    response.should be_redirect
    response.should redirect_to('/parent')
  end

  it "should redirect to an existent page when called without .xml (and with some parameters)" do
    get 'index', :url => ['parent'], :keywords => ['blah']
    response.should be_redirect
    response.should redirect_to('/parent')
  end

  it "should serve a response when asked nicely" do
    get 'index', :url => ['parent'], :format => 'xml'
    response.should be_success
  end

  it "should serve a response when called with the \"keywords\" parameter" do
   get 'index', :url => ['parent'], :keywords => 'blah', :format => 'xml'
    response.should be_success
  end

  it "should assign correctly @page and @pages" do
    get 'index', :url => ['parent'], :format => 'xml'
    assigns[:page].should == Page.find_by_url('/parent')
    assigns[:pages].should == Page.find_by_url('/parent').children.find(:all, :order => "published_at DESC")
  end

  it "should find pages using keywords" do
    c2 = Page.find_by_url('/parent/child-2')
    c2.keywords = "foo"
    c2.save!
    get 'index', :url => ['parent'], :format => 'xml', :keywords => ['foo']
    assigns[:pages].should == [c2]
  end

  it "should avoid finding pages with keywords containing the requested ones (prefix)" do
    c2 = Page.find_by_url('/parent/child-2')
    c2.keywords = "foobar"
    c2.save!
    get 'index', :url => ['parent'], :format => 'xml', :keywords => ['foo']
    assigns[:pages].should == []
  end

  it "should avoid finding pages with keywords containing the requested ones (suffix)" do
    c2 = Page.find_by_url('/parent/child-2')
    c2.keywords = "foobar"
    c2.save!
    get 'index', :url => ['parent'], :format => 'xml', :keywords => ['bar']
    assigns[:pages].should == []
  end

  it "should find 30 pages even if not all of the first 30 found do not contain the searched keywords" do
    create_page "Feed" do
      create_page "FeedChild with no keywords"
      30.times do |i|
        create_page "FeedChild #{i}", :keywords => "foo"
      end
    end
    get 'index', :url => ['feed'], :format => 'xml', :keywords => ['foo']
    assigns[:pages].length.should == 30
    assigns[:pages].any?{|p| p.title == "FeedChild with no keywords"}.should == false
  end

  describe "with caching" do
  integrate_views
    it "should use caching" # do
#      @controller.cache.clear
#      @controller.cache.response_cached?('/rss/parent.xml').should == false
#      get 'index', :url => ['parent'], :format => 'xml'
#      @controller.cache.response_cached?('/rss/parent.xml').should == true
#    end
  end
end
