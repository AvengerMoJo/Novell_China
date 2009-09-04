require 'socket'

module Suse  
  # represents an user at SUSE
  # u = User.find('dmacvicar')
  # puts u.name
  #
  class User
    LDAP_QUERY=""
    attr_accessor :login, :name, :employee_number
    attr_accessor :manager_number, :mail
    attr_accessor :location, :unit, :cost_center, :phone

    def self.find(id)
      users = nil
      case id
      when String # assume it is login
        return User.find_by_query("ldapsearch -h ldap.suse.de -b o=novell -x uid=#{id}")
      when Integer # workforce id        
        return User.find_by_query("ldapsearch -h ldap.suse.de -b o=novell -x employeeNumber=#{id}")
      else
        raise "Can't lookup user using #{id}"
      end
    end

    # executes the program and returns the output
    def self.execute_ldapsearch_query(query)
      `#{query}`
    end
    
    # finds users by arbitrary ldap query
    def self.find_by_query(query)
      result = []
      # items found
      total = 0
      output = User.execute_ldapsearch_query(query)
      user = nil
      output.each_line do |line|
        if line =~ /^dn/
          result << user if not user.nil?
          user = User.new
        end
        user.login = line.split(': ')[1].chop if line =~ /^uid: /
        user.name = line.split(': ')[1].chop if line =~ /^cn: /
        user.mail = line.split(': ')[1].chop.downcase if line =~ /^mail: /
        user.employee_number = line.split(': ')[1].chop.to_i if line =~ /^employeeNumber: /
        user.manager_number = line.split(': ')[1].chop.to_i if line =~ /^managerWorkforceID: /
        user.location = line.split(': ')[1].chop.gsub( /\(/,'\\\28').gsub( /\)/,'\\\29')  if line =~ /^l: /
        user.unit = line.split(': ')[1].chop if line =~ /^ou: /
        user.cost_center = line.split(': ')[1].chop if line =~ /^costCenter: /
        user.phone = line.split(': ')[1].chop if line =~ /^telephoneNumber: /
        total = line.split(': ')[1].chop.to_i if line =~ /^# numEntries: /
      end
      # make sure last result is also added
      result << user if not user.nil?
      
      if total != result.size
        raise "Ups! #{total} #{result.size}"
      end
      
      return nil if result.empty?
      return result.first if result.size == 1
      return result
    end

    # empty user
    def initialize
      
    end
    
    def valid?
      not login.nil? and not name.nil? and not employee_number.nil?
    end
    
    def manager
      return User.find(@manager_number)
    end

    def team
      return User.find_by_query("ldapsearch -h ldap.suse.de -b o=novell -x managerWorkforceID=#{@employee_number}")
    end

    def site
      return User.find_by_query("ldapsearch -h ldap.suse.de -b o=novell -x l='#{@location}'")
    end

    def local_team( cost_centers )
      q_cc = "(|"
      cost_centers.each do | cost_center |
          q_cc += "(costCenter=" + cost_center + ")"
      end
      q_cc += ")"
      return User.find_by_query("ldapsearch -h ldap.suse.de -b o=novell -x \"(&(l=#{@location})"+q_cc+")\"")
    end

    # calls present for data
    def execute_present_query
      present = TCPSocket.new('present.suse.de', 9874)
      present.puts(login + "\n")
      present.read
    end
    
    # iterates over each vacation interval
    # u.each_vacation do |start, end|
    # end
    def each_vacation
      present = TCPSocket.new('present.suse.de', 9874)
      present.puts(login + "\n")
      data = execute_present_query

      states = [ :login, :separator, :absence_title, :absence ]
      state = :separator

      data.each_line do | line |
        state = :login if (line =~ /^Login\s*:\s*#{login}\s*$/)
        state = :separator if (line =~ /^-+\s*$/)
        state = :absence_title if (state == :login && line =~ /^Absence\s*:\s/)

        if ( state ==  :absence_title )
          if (line =~ /(Mon|Tue|Wed|Thu|Fri|Sat|Sun) (\d{4})-(\d{2})-(\d{2}) - (Mon|Tue|Wed|Thu|Fri|Sat|Sun) (\d{4})-(\d{2})-(\d{2})\s*$/)
            from = Time.local($2.to_i, $3.to_i,$4.to_i)
            till = Time.local($6.to_i, $7.to_i,$8.to_i)
            #STDERR.puts "#{login}: from #{from} till #{till}"
            yield from, till
          end
        end
      end
      
    end

  end    
  
end
