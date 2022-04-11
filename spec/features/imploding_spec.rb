require 'rails_helper'

RSpec.feature 'Imploding', type: :feature do
  before do
    FactoryBot.create_list(:video, 2, status: 'ready')
  end

  scenario 'someone from gifsound.com' do
    visit '/?gifv=jIEmIY8&v=ml_exyAiobQ&s=7'
    expect(page).to have_content('Making your video')
  end

  scenario "as a friend" do
    visit "/"
    expect(page).to have_content('imploder')
    expect(page).to have_selector('.implosion', count: 2)
    click_link 'Create an Implosion'
    fill_in 'Gif Url', with: 'http://imgur.com/stuff.gif'
    fill_in 'Youtube Url', with: 'http://youtube.com/&v=ml-things'
    fill_in 'Audio Start Delay', with: '2'
    click_button 'Implode!'
    expect(page).to have_content('Making your video')
  end
end
