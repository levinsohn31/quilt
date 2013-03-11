class ApplicationController < ActionController::Base
  protect_from_forgery
	
	# https://github.com/weppos/tabs_on_rails
  class TabsOnRails::Tabs::TabsBuilder
  	def tab_for(tab, name, options, item_options = {})
  	  item_options[:class] = (current_tab?(tab) ? 'selected' : '')
  	  @context.content_tag(:li, item_options) do
  	    @context.link_to(name, options)
  	  end
  	end
	end	
end
