require 'spec_helper'

require 'douban/people'

module Douban
  describe People do
    before do
      @s = <<eos
<?xml version="1.0" encoding="UTF-8"?>
<entry xmlns="http://www.w3.org/2005/Atom" xmlns:db="http://www.douban.com/xmlns/" xmlns:gd="http://schemas.google.com/g/2005" xmlns:openSearch="http://a9.com/-/spec/opensearchrss/1.0/" xmlns:opensearch="http://a9.com/-/spec/opensearchrss/1.0/">
	<id>http://api.douban.com/people/41502874</id>
	<title>SJo1pHHJGmCx</title>
	<link href="http://api.douban.com/people/41502874" rel="self"/>
	<link href="http://www.douban.com/people/41502874/" rel="alternate"/>
	<link href="http://t.douban.com/icon/user.jpg" rel="icon"/>
	<content></content>
	<db:signature></db:signature>
	<db:uid>41502874</db:uid>
	<uri>http://api.douban.com/people/41502874</uri>
</entry>
eos
    end

    it 'should correct deserialize from string' do
      people = Douban::People.new(@s)
      people.id.should == "http://api.douban.com/people/41502874"
      people.location.should == nil
      people.title.should == 'SJo1pHHJGmCx'
      people.link.should == {"self"=>"http://api.douban.com/people/41502874",
        "alternate"=>"http://www.douban.com/people/41502874/",
        "icon"=>"http://t.douban.com/icon/user.jpg"}
      people.content.should == nil
      people.uid.should == '41502874'
    end

    it "should support ==" do
      People.new(@s).should == People.new(@s)
    end

    it "should support deserialize from REXML::Document" do
      People.new(REXML::Document.new(@s)).should == People.new(@s)
    end

    it "should support deserialize from REXML::Element" do
      People.new(REXML::Document.new(@s).root).should == People.new(@s)
    end
  end
end

