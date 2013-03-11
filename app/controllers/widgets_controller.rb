class WidgetsController < ApplicationController
  def index
  	set_tab :widgets
  end
  
  def signin
    set_tab :widgets
    set_tab :signin, :tabnav
  end

  def editProfile
    set_tab :widgets
    set_tab :editProfile, :tabnav
  end

  def components
  	set_tab :widgets
  	set_tab :components, :tabnav
  end
end
