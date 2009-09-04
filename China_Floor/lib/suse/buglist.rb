#!/usr/bin/env ruby
require 'cgi'
require 'rubygems'
require "rexml/document"
require 'open-uri'
require 'uri'
require 'getoptlong'
require 'suse/bug'
require 'suse/utils'
require 'suse/bugs'

require 'rubygems'
require 'mechanize'

module Suse
  
BZ_URL = "https://bugzilla.novell.com"
BZ_BUGLIST = "#{BZ_URL}/buglist.cgi"
BZ_SHOWBUG = "#{BZ_URL}/show_bug.cgi"
  
#
#
# Small DSL to query bugzilla
#
# Some examples:
# list = BugList.new
# list.use_osc_credentials
# list.login
#
# list.opened.field(:assigned_to, :equals, team).and.field(:short_desc, :substring, 'L3')
# 
# list.severity(:blocker).component("libzypp").severity(:critical).status(:new).product("openSUSE 11.2").each_bug do |bug|
#   puts bug
# end
#
# list.to_ics
# list.to_xml
#
class BugList
  
  def initialize
    clear!
  end

  def clear!
    @url = URI.parse(BZ_BUGLIST)
    # boolean chart setup
    @or_set = 0
    @and_set = 0
    @chart_set = 0
    @advanced_mode = false
    @agent = WWW::Mechanize.new
    @uri_params = []
  end
  
  def oscrc
    File.join(ENV["HOME"], ".oscrc")
  end

  def osc_credentials
    # steal credentials from osc
    ini = Suse::Utils::tame(File.open(oscrc).read)
    if ini.has_key?("http://api.suse.de")
      user, pass = ini["http://api.suse.de"]["user"], ini["http://api.suse.de"]["pass"]
    else
      raise "No credentials in oscrc"
    end
    "#{user}:#{pass}"
  end
  
  def use_osc_credentials
    creds = osc_credentials
    @username, @password = osc_credentials.split(':')
    #@url.userinfo = osc_credentials
  end

  def login
    @agent.get("https://bugzilla.novell.com/ICSLogin/?%22https://bugzilla.novell.com/ichainlogin.cgi?target=index.cgi?GoAheadAndLogIn%3D1%22") do |page|
      page.form_with(:action => "auth-up") do |form|
        #form.fields.each { |f| puts f.name }
        form['username'] = @username
        form['password'] = @password
      end.submit
    end
  end
  
  # severity :critial, :blocker
  def severity(v)
    add_query(:bug_severity, v, Proc.new {|v| v.capitalize})
  end

  #status ( :new, :assigned )
  def status(v)
    add_query(:bug_status, v, Proc.new {|v| v.upcase})
  end

  # component, ie: "YaST2"
  def component(v)
    add_query(:component, v, Proc.new {|v| CGI.escape(v)})
  end

  # product, ie: "openSUSE 11.2"
  def product(v)
    add_query(:product, v, Proc.new {|v| CGI.escape(v)})
  end

  #
  # adds a field to the boolean chart
  # ie: list.field(:assigned_to, :equals, "L3")
  # also works with arrays, which means OR
  def field(field_name, op, value)
    if not @advanced_mode
      @advanced_mode = true
      add_query(:query_format, :advanced)
    end
    [*value].each do |item|
      add_query("field#{@chart_set}-#{@and_set}-#{@or_set}", field_name, Proc.new {|v| CGI.escape(v)})
      add_query("type#{@chart_set}-#{@and_set}-#{@or_set}", op, Proc.new {|v| CGI.escape(v)})
      add_query("value#{@chart_set}-#{@and_set}-#{@or_set}", item, Proc.new {|v| CGI.escape(v)})
      @or_set += 1
    end
    return self
  end

  def opened
    status(:new).status(:assigned).status(:needinfo).status(:reopened)#.field(:bug_status, :anyexact, "NEW,ASSIGNED,NEEDINFO,REOPENED")
  end
  
  # or connector for boolean charts
  # only decorator
  def or
    self
  end

  # and connector for charts
  def and
    @and_set += 1
    @or_set = 0
    self
  end
  
  def url
    @url.query = Suse::Utils::query_string(@uri_params)
    @url
  end

  def to_rss
    to_format(:rss)
  end

  def to_ics
    to_format(:ics)
  end

  def to_csv
    to_format(:csv)
  end

  def to_format(format)
    @url.query = Suse::Utils::query_string([ Suse::Utils::UriParam.new(:ctype, format), *@uri_params])
    @agent.get(@url).body
  end

  # returns the ids of this query result
  def list_ids
    doc = REXML::Document.new to_rss
    bugids = doc.elements.each("feed/entry") {}.to_a.map do |e|
      if e.elements['id'].text =~ /htt.+?id=(\d+)/
        $1
      else
        nil
      end
    end.select { |x| x }
  end
  
  def to_xml
    params = []
    params << Suse::Utils::UriParam.new(:ctype, :xml)
    params << Suse::Utils::UriParam.new(:excludefield, :attachmentdata)
    list_ids.each { |id| params << Suse::Utils::UriParam.new(:id, id.to_s) }
    uri = URI.parse(BZ_SHOWBUG)
    uri.query = Suse::Utils::query_string(params)
    #puts uri.to_s
    xml = @agent.get(uri).body
  end
  
  def each_bug
    bugs.each { |bug| yield bug }
  end

  def bugs
    parser = Suse::BugParser.new
    parser.parse_bugs(to_xml)
  end
    
  private
  
  def add_query(key, value, transform = Proc.new {|v| v})
    query = (@url.query || "").split('&')
    # apply the lambda
    transformed = transform.call(value.to_s)
    param = Suse::Utils::UriParam.new(key, transformed)
    @uri_params << param
    yield self if block_given?
    self
  end
end 

end # module suse


