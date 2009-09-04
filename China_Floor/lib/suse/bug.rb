module Suse

  class Bug
    
    attr_accessor :bug_id, :short_desc, :creation_ts, :short_desc, :delta_ts, :reporter_accessible,:cclist_accessible,:classification_id,:classification,:product,:component,:version,:rep_platform,:op_sys,:bug_status,:priority,:bug_severity,:target_milestone,:everconfirmed,:reporter,:assigned_to,:estimated_time,:remaining_time,:actual_time,:infoprovider,:qa_contact,:cf_foundby,:token

    def bug_url
      "#{BZ_SHOWBUG}?id=#{bug_id}"
    end
    
    def initialize
      @attributes = {}
    end
    
    def title
      short_desc
    end

    def to_s
      return "#{title} (#{bug_id})"
    end

  end


  class BugParser

    def initialize()
    end

    # retrieve bug data for a list of ids
    def parse_bugs(xml)
      bugs = []
      doc = REXML::Document.new(xml)
      doc.elements.each("bugzilla/bug") do |e|
        bug = Suse::Bug.new
        [:bug_id, :short_desc, :creation_ts, :short_desc, :delta_ts, :reporter_accessible,:cclist_accessible,:classification_id,:classification,:product,:component,:version,:rep_platform,:op_sys,:bug_status,:priority,:bug_severity,:target_milestone,:everconfirmed,:reporter,:assigned_to,:estimated_time,:remaining_time,:actual_time,:infoprovider,:qa_contact,:cf_foundby,:token].each do |attr|
          if bug.respond_to?(attr)
            next if e.elements[attr.to_s].nil?
            bug.send("#{attr}=".to_sym, e.elements[attr.to_s].text)
          else
            raise "bug element has no key: #{attr}, only: #{e.elements.each {}.to_a.map { |x| x.name }.join(',')}"
          end
        end
        bugs << bug
      end
      bugs
    end
    
  end

end

