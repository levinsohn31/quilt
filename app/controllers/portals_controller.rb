class PortalsController < ApplicationController
	def index
  	set_tab :portals
  end
  
  def zendesk
  	set_tab :portals
  	set_tab :zendesk, :tabnav
  end

end
