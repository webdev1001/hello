require 'spec_helper'

BDD.inject.uic "Dual Form" do

  scenario "Empty Form" do
    When "I sign up with an empty form" do
      visit hello.root_path
      click_button 'Sign Up'
    end

    Then "I should see an error message" do
      expect_to_see "found while trying to sign up"
    end

    Then "and be on the sign up page" do
      expect(current_path).to eq hello.sign_up_path
    end
  end

end
