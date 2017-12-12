RSpec.describe Capybara::Jsdom, type: :feature do
  it "has a version number" do
    expect(Capybara::Jsdom::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(true).to eq(true)
  end

  5.times do
    it "loads a page" do
      time do
        visit "/frank-says"
        # visit "http://www.something.com/"
        # visit "http://localhost:3000/sign_in"
        # visit "https://app.joblab.com/sign_in"

        # expect(page).to have_content("Sinatra")
        expect(page).to have_css("p")
      end
    end
  end
end
