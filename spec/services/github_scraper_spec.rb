require 'rails_helper'

RSpec.describe GithubScraper, type: :service do
  let(:profile_url) { "https://github.com/joao-henrique-rebase" }
  let(:contributions_url) { "https://github.com/users/joao-henrique-rebase/contributions" }

  let(:profile_html) do
    <<-HTML
      <div class="p-nickname vcard-username">joao-henrique-rebase</div>
      <img class="avatar avatar-user" src="https://github.com/avatar/joao-henrique-rebase.png">
      <a href="?tab=followers"><span>200</span></a>
      <a href="?tab=following"><span>150</span></a>
      <nav><a href="?tab=stars"><span class="Counter">50</span></a></nav>
      <div class="vcard-detail"><span class="p-org">Fretadao</span></div>
      <div class="vcard-detail"><span class="p-label">Sao Paulo, Brazil</span></div>
    HTML
  end

  let(:contributions_html) do
    <<-HTML
      <div class="js-yearly-contributions">
        <h2 class="f4">600 contributions in the last year</h2>
      </div>
    HTML
  end

  before do
    stub_request(:get, profile_url).to_return(status: 200, body: profile_html)
    stub_request(:get, contributions_url).to_return(status: 200, body: contributions_html)
  end

  describe ".call" do
    context "when given a valid profile URL" do
      it "returns the correct profile data" do
        result = GithubScraper.call(profile_url)

        expect(result).to include(
          nickname: "joao-henrique-rebase",
          avatar_url: "https://github.com/avatar/joao-henrique-rebase.png",
          followers_count: "200",
          following_count: "150",
          stars_count: "50",
          contributions: 600,
          organization: "Fretadao",
          location: "Sao Paulo, Brazil"
        )
      end
    end
  end

  context "when the URL is empty" do
    it "raises a ScraperError with the message 'Empty URL'" do
      expect { GithubScraper.call("") }.to raise_error(GithubScraper::ScraperError, /Empty URL/)
    end
  end

  context "when the URL cannot be accessed" do
    before do
      stub_request(:get, profile_url).to_raise(StandardError.new("Connection failed"))
    end

    it "raises a ScraperError with the message 'Failed to open URL'" do
      expect { GithubScraper.call(profile_url) }.to raise_error(GithubScraper::ScraperError, /Failed to open URL/)
    end
  end
end
