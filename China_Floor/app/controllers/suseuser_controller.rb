require 'suse/user'
#require 'getoptlong'
#require 'logger'
#$: << File.join(File.dirname(__FILE__), "..", "lib")

class SuseuserController < ApplicationController
  caches_page :index
  # caches_action :index
  def index
    sit = Sit.find( params[:id] )
    if sit.used 
        @userid = sit.user
        @user = Suse::User.find( sit.user.to_s )
    else
	render :inline => "<img id=user-info-close-icon src='/images/close.png' onclick='person_info(false);'/><h1>Empty Sit</h1>"
    end
  end
end
