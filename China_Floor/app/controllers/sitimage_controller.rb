require 'RMagick'
# require "Sits"
#Mime::Type.register "image/png", :png
#Mime::Type.register "image/jpg", :jpg

class SitimageController < ApplicationController
  caches_page :show, :new

  # Get /sitimage/new
  def new
    respond_to do |format|
      format.png do
	canvas = Magick::Image.new(12, 12 ){ self.background_color = 'none' }
        drawable = Magick::Draw.new
        drawable.circle( 6, 6, 0, 6)
        drawable.fill = 'blue'
        drawable.gravity = Magick::CenterGravity
        drawable.draw(canvas)
        canvas.format = "PNG"
        send_data canvas.to_blob, :filename => "new.png", 
                                  :disposition => 'inline', 
                                  :type => "image/png" 
      end
    end
  end

  # GET /sitimage/1
  def show
    @sit = Sit.find(params[:id])
    # @order = Order.find(params[:id])
    # @sit = Sits.find(params[:id])
    respond_to do |format|
      format.html do
        # Render the show.rhtml template
      end

      format.png do
        # Show cart icon with number of items in it
        # icon = Magick::Image.read("#{RAILS_ROOT}/public/images/cart.png").first
        # icon = Magick::Image.new(240, 300, Magick::HatchFill.new('white','lightcyan2'))
        # drawable.font = ("#{RAILS_ROOT}/artwork/fonts/VeraMono.ttf")
	# granite = Magick::ImageList.new('granite:')
	#canvas.new_image(10, 10, Magick::TextureFill.new(granite))
	canvas = Magick::Image.new(12, 12 ){ self.background_color = 'none' }
	text = Magick::Image.new(12, 12 ){ self.background_color = 'none' }

        # icon = Magick::Image.new( 10,10 ); 
        drawable = Magick::Draw.new
        text = Magick::Draw.new
        #drawable.stroke('green')
        #drawable.stroke_width(1)
        drawable.gravity = Magick::CenterGravity
        drawable.circle( 6, 6, 0, 6 )
        if @sit.used == true
           drawable.fill = 'lightgreen'
        else 
           drawable.fill = 'lightcoral'
        end
        drawable.draw(canvas)

        text.font = ("/usr/share/fonts/truetype/FreeSans.ttf")
        text.font_family = 'helvetica'
        text.pointsize = 9
        text.gravity = Magick::CenterGravity
        text.annotate(canvas, 0,0,0,0, params[:id]) { self.fill = 'black' }
        canvas.format = "PNG"
        send_data canvas.to_blob, :filename => "1.png", 
                                  :disposition => 'inline', 
                                  :type => "image/png" 
      end
      format.jpg do
        icon = Magick::Image.new( 10,10 ); 

        drawable = Magick::Draw.new
        drawable.stroke('red')
        drawable.stroke_width(3)
        drawable.fill = 'green'
        drawable.gravity = Magick::CenterGravity
        drawable.draw(icon)
        icon.format = "JPEG"
        send_data icon.to_blob, :filename => "1.jpg", 
                                :disposition => 'inline', 
                                :type => "image/jpg" 
      end
    end
  end
end
