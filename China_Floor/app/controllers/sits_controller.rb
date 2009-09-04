class SitsController < ApplicationController
  # GET /sits
  # GET /sits.xml
  def index
    @sits = Sit.find(:all)
    @viewonly = params[:viewonly]
    flash[:notice] = 'Green is being used sit, Red is empty sit.'

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sits }
    end
  end

  # GET /sits/1
  # GET /sits/1.xml
  def show
    @sits = Sit.find(:all)
    @sit = Sit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sit }
    end
  end

  # GET /sits/new
  # GET /sits/new.xml
  def new
    @sits = Sit.find(:all)
    @sit = Sit.new

    respond_to do |format|
      flash[:notice] = 'Beware you are creating a new sitting.'
      format.html # new.html.erb
      format.xml  { render :xml => @sit }
    end
  end

  # GET /sits/1/edit
  def edit
    @sits = Sit.find(:all)
    @sit = Sit.find(params[:id])
    flash[:notice] = 'Beware you are updating the current sitting.'
  end

  # POST /sits
  # POST /sits.xml
  def create
    @sit = Sit.new(params[:sit])

    respond_to do |format|
      if @sit.save
        flash[:notice] = 'Sit was successfully created.'
        format.html { redirect_to(@sit) }
        format.xml  { render :xml => @sit, :status => :created, :location => @sit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sits/1
  # PUT /sits/1.xml
  def update
    @sit = Sit.find(params[:id])

    respond_to do |format|
      if @sit.update_attributes(params[:sit])
        flash[:notice] = 'Sit was successfully updated.'
        format.html { redirect_to(@sit) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sits/1
  # DELETE /sits/1.xml
  def destroy
    @sit = Sit.find(params[:id])
    @sit.destroy

    respond_to do |format|
      format.html { redirect_to(sits_url) }
      format.xml  { head :ok }
    end
  end
end
