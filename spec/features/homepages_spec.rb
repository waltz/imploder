require 'rails_helper'

RSpec.feature "Homepage", type: :feature do
  scenario "loading the homepage" do
    visit "/"
    expect(page).to have_content("gif imploder")
  end
end
