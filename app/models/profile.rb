class Profile < ApplicationRecord
  validates :name, presence: true
  validates :github_url, presence: true
end
