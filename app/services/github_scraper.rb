require 'nokogiri'
require 'open-uri'

class GithubScraper
  class ScraperError < StandardError; end

  BASE_URL = "https://github.com".freeze

  SELECTORS = {
    nickname:        ".p-nickname.vcard-username",
    avatar_url:      ".avatar.avatar-user",
    followers_count: "a[href$='tab=followers'] span",
    following_count: "a[href$='tab=following'] span",
    stars_count:     "nav a[href$='tab=stars'] span.Counter",
    contributions:   ".js-yearly-contributions h2.f4",
    organization:    ".vcard-detail span.p-org",
    location:        ".vcard-detail span.p-label"
  }.freeze

  def self.call(profile_url)
    new(profile_url).call
  end

  attr_reader :profile_url, :profile_document, :contributions_document

  def initialize(profile_url)
    @profile_url = profile_url
  end

  def call
    validate!
    @profile_document, @contributions_document = fetch_documents
    build_result
  end

  private

  def validate!
    raise ScraperError, "Empty URL" if profile_url.blank?
  end

  def fetch_documents
    [profile_url, contributions_url(profile_url)].map do |url|
      Nokogiri::HTML(URI.open(url))
    rescue StandardError => e
      raise ScraperError, "Failed to open URL: #{e.message}"
    end
  end

  def build_result
    {
      nickname:        extract_text(SELECTORS[:nickname]),
      avatar_url:      extract_img(SELECTORS[:avatar_url]),
      followers_count: extract_text(SELECTORS[:followers_count]),
      following_count: extract_text(SELECTORS[:following_count]),
      stars_count:     extract_text(SELECTORS[:stars_count]),
      contributions:   extract_text_contributions(SELECTORS[:contributions]),
      organization:    extract_text(SELECTORS[:organization]),
      location:        extract_text(SELECTORS[:location])
    }
  end

  def extract_text(selector)
    profile_document.at_css(selector)&.text&.strip
  end

  def extract_text_contributions(selector)
    contributions_document.at_css(selector)&.text&.strip&.gsub(/\D/, '')&.to_i
  end

  def extract_img(selector)
    profile_document.at_css(selector)&.[]('src')&.strip
  end

  def contributions_url(profile_url)
    username_url = profile_url.gsub(%r{https?://(www\.)?github\.com/}, '').split('/').first
    "#{BASE_URL}/users/#{username_url}/contributions"
  end
end
