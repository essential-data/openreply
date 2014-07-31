module ControllerMacros

  def login_admin
	  before(:each) do
	    # TODO dont know what its doing
	    @request.env["devise.mapping"] = Devise.mappings[:admin]
	    sign_in FactoryGirl.create(:admin2) # Using factory girl as an example
	  end
	end
end