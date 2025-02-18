require 'nokogiri'
require 'open-uri'

class GithubScraper
  class ScraperError < StandardError; end

  SELECTORS = {
    nickname:        ".p-nickname.vcard-username",
    avatar_url:      ".avatar.avatar-user",
    followers_count: "a[href$='tab=followers'] span",
    following_count: "a[href$='tab=following'] span",
    stars_count:     "nav a[href$='tab=stars'] span.Counter",
    contributions:   ".js-yearly-contributions",
    organization:    ".vcard-detail span.p-org",
    location:        ".vcard-detail span.p-label"
  }.freeze

  def self.call(profile_url)
    new(profile_url).call
  end

  attr_reader :profile_url, :document

  def initialize(profile_url)
    @profile_url = profile_url
  end

  def call
    validate_url!
    @document = fetch_document
    build_result
  end

  private

  def validate_url!
    raise ScraperError, "Empty URL" if profile_url.blank?
  end

  def fetch_document
    Nokogiri::HTML(URI.open(profile_url))
  rescue StandardError => e
    raise ScraperError, "Failed to open URL: #{e.message}"
  end

  def build_result
    {
      nickname:        extract_text(SELECTORS[:nickname]),
      avatar_url:      extract_img(SELECTORS[:avatar_url]),
      followers_count: extract_text(SELECTORS[:followers_count]),
      following_count: extract_text(SELECTORS[:following_count]),
      stars_count:     extract_text(SELECTORS[:stars_count]),
      contributions:   extract_text(SELECTORS[:contributions])&.gsub(/\D/, '')&.to_i,
      organization:    extract_text(SELECTORS[:organization]),
      location:        extract_text(SELECTORS[:location])
    }
  end

  def extract_text(selector)
    document.at_css(selector)&.text&.strip
  end

  def extract_img(selector)
    document.at_css(selector)&.[]('src')&.strip
  end
end
