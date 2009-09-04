require 'suse/user'
#require 'getoptlong'
#require 'logger'
#$: << File.join(File.dirname(__FILE__), "..", "lib")

class TeamController < ApplicationController
  caches_action :index
  def index
    user = Suse::User.find('allau')
                #  Desktop   Server    QA        L3 Maint.  Labs
    if params[:department] == nil
      costcenters = ["*74510", "*70010", "*70430", "*70390", "*70290" ]
    else 
      costcenters = []
      costcenters << "*74510" if params[:department].downcase.include? "desktop"
      costcenters << "*70010" if params[:department].downcase.include? "server"
      costcenters << "*70430" if params[:department].downcase.include? "qa"
      costcenters << "*70390" if params[:department].downcase.include? "l3"
      costcenters << "*70290" if params[:department].downcase.include? "lab"
    end 
    # @team = user.local_team(costcenters).each do |member|
    @team = user.local_team(costcenters)

    @login = true if params[:info].include? "login"
    @name = true if params[:info].include? "name"
    @mail = true if params[:info].include? "mail"
    @phone = true if params[:info].include? "phone"
    if ( params[:format] == nil )
      render :layout => false, :template => 'team/index'
      #render :layout =>true, :partial => "/layouts/list.html.erb"
    end  
  end
end
