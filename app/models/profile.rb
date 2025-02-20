class Profile < ApplicationRecord
  before_save :generate_short_code, if: -> { short_code.blank? }

  validates :name, presence: true
  validates :github_url, presence: true, uniqueness: true
  validates :short_code, uniqueness: true, allow_nil: true

  private

  def generate_short_code
    loop do
      self.short_code = SecureRandom.alphanumeric(6)
      break unless Profile.exists?(short_code: short_code)
    end
  end
end
