class DashboardController < ApplicationController
  def index
  	set_tab :dashboard
  end
  
  def base
  	set_tab :dashboard
  	set_tab :base, :tabnav
  end
  
  def navigation
  	set_tab :dashboard
  	set_tab :navigation, :tabnav
  end
  
  def grid
  	set_tab :dashboard
  	set_tab :grid, :tabnav
  end
  
  def buttons
  	set_tab :dashboard
  	set_tab :buttons, :tabnav
  end
  
  def messages
  	set_tab :dashboard
  	set_tab :messages, :tabnav
  end
  
  def tables
  	set_tab :dashboard
  	set_tab :tables, :tabnav
  end
  
  def forms
  	set_tab :dashboard
  	set_tab :forms, :tabnav
  end
  
  def wizard
  	set_tab :dashboard
  	set_tab :wizard, :tabnav
  end
end
