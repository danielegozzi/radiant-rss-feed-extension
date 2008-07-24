require File.dirname(__FILE__) + '/../spec_helper'

describe RssHelper do
  
  #Delete this example and add some real ones or delete this file
  it "should include the RssHelper" do
    included_modules = self.metaclass.send :included_modules
    included_modules.should include(RssHelper)
  end
  
end
