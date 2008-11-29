require'rexml/document'
module Douban
  class Subject
    class<<self
      def attr_names
        [
          :id,
          :title,
          :category,
          :author,
          :link,
          :summary,
          :attribute,
          :tag,
          :rating
        ]
      end
    end
    attr_names.each do |attr|
      attr_accessor attr
    end
   def initialize(atom='')
     begin
      doc=REXML::Document.new(atom)
      id=REXML::XPath.first(doc,"//id")
      @id=id.text if !id.nil?
      title=REXML::XPath.first(doc,"//title")
      @title=title.text if !title.nil?
      @category={}
      category=REXML::XPath.first(doc,"//category")
      @category['term']=category.attributes['term'] if !category.nil?
      @category['scheme']=category.attributes['scheme'] if !category.nil?
      REXML::XPath.each(doc,"//db:tag") do |tag|
        @tag||={}
        @tag[tag.attributes['name']]=tag.attributes['count']
      end
      @author||=Author.new
      name=REXML::XPath.first(doc,"//author/name")
      @author.name=name.text if !name.nil?
      uri=REXML::XPath.first(doc,"//author/uri")
      @author.uri=uri.text if !uri.nil?
      REXML::XPath.each(doc,"//author/link") do |link|
        @author.link||={}
        @author.link[link.attributes['rel']]=link.attributes['href']
      end
      summary=REXML::XPath.first(doc,"//summary")
      @summary=summary.text if !summary.nil?
      REXML::XPath.each(doc,"//link") do |link|
        @link||={}
        @link[link.attributes['rel']]=link.attributes['href']
      end
      REXML::XPath.each(doc,"//db:attribute") do |attribute|
        @attribute||={}
        @attribute[attribute.attributes['name']]=attribute.text
      end
      @rating={}
      rating=REXML::XPath.first(doc,"//gd:rating")
      @rating['min']=rating.attributes['min'] if !rating.nil?
      @rating['numRaters']=rating.attributes['numRaters'] if !rating.nil?
      @rating['average']=rating.attributes['average'] if !rating.nil?
      @rating['max']=rating.attributes['max'] if !rating.nil?
     rescue
     ensure
      self
     end
     
   end
 end
  class Author
    class<<self
      def attr_names
        [
          :uri,
          :link,
          :name
        ]
      end
    end
    attr_names.each do |attr|
      attr_accessor attr
    end
    def initialize(entry="")
      begin
       doc=REXML::Document.new(entry)
       REXML::XPath.each(doc,"//link") do|link|
        @link||={}
        @link[link.attributes['rel']]=link.attributes['href']
      end
       name=REXML::XPath.first(doc,"//author/name")
       @name=name.text if !name.nil?
       uri=REXML::XPath.first(doc,"//author/uri")
       @uri=uri.text if !uri.nil?
      rescue
      ensure
       self
      end
    end
  end
  class Movie<Subject
    def initialize(atom)
      super(atom)
    end
  end
  class Book<Subject
    def initialize(atom)
      super(atom)
    end
  end
  class Music<Subject
    def initialize(atom)
      super(atom)
    end
  end
 end

    