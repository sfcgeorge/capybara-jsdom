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

        expect(page).to have_css("p")
      end
    end
  end

  context "visit address" do
    before { visit "/frank-says" }

    shared_examples "scoped matchers" do
      it "uses matcher have_css" do
        expect(scope).to have_css("p")
        expect(scope).not_to have_css("foo")
      end

      it "uses matcher have_xpath" do
        expect(scope).to have_xpath("//p")
        expect(scope).not_to have_xpath("//foo")
      end

      it "uses matcher have_content" do
        expect(scope).to have_content("Put this in your pipe")
        expect(scope).not_to have_content("A bowl of petunias")
      end
    end

    context "page" do
      let(:scope) { page }
      it_should_behave_like "scoped matchers"
    end

    context "node" do
      let(:scope) { find("#scoped") }
      it_should_behave_like "scoped matchers"
    end

    context "node actions" do
      it "can fill_in" do
        expect(find('[name="filled"]').value).to eq "Existing Data"
        fill_in("handle", with: "_why")
        expect(find('[name="handle"]').value).to eq "_why"
      end

      it "can check" do
        check("checker")
        expect(find('[name="checker"]')).to be_checked
        uncheck("checker")
        expect(find('[name="checker"]')).not_to be_checked
      end

      it "can click" do
        find('[name="checker"]').click
        expect(find('[name="checker"]')).to be_checked
        find('[name="checker"]').click
        expect(find('[name="checker"]')).not_to be_checked
      end

      it "can double click" do
        find('[name="checker"]').double_click
        expect(find('[name="checker"]')).not_to be_checked
        find('[name="checker"]').click
        find('[name="checker"]').double_click
        expect(find('[name="checker"]')).to be_checked
      end

      it "can trigger" do
        find('[name="checker"]').trigger :click
        expect(find('[name="checker"]')).to be_checked
        find('[name="checker"]').trigger :click
        expect(find('[name="checker"]')).not_to be_checked
      end
    end

    context "misc" do
      it "has ==" do
        p1 = first("p")
        p2 = first("p")
        input = first("input")
        expect(p1).to eq p2
        expect(p1).not_to eq input
      end

      it "has path" do
        expect(find("#scoped").path).to eq %(id("scoped"))
        expect(first("p").path).to eq %(BODY/P[1])
      end
    end
  end
end
