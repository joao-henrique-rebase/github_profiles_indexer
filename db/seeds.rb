profiles = [
  {
    name: "Joao Vale",
    nickname: "joao-henrique-rebase",
    followers_count: "17",
    following_count: "10",
    stars_count: "2",
    contributions_count_last_year: 486,
    avatar_url: "https://avatars.githubusercontent.com/u/26904047?v=4",
    github_url: "https://github.com/joao-henrique-rebase",
    organization: "https://www.rebase.com.br/",
    location: "São Paulo, Brazil",
    short_code: "nVs4sI"
  },
  {
    name: "Rafael Mendonça França",
    nickname: "rafaelfranca",
    followers_count: "3.4k",
    following_count: "47",
    stars_count: "89",
    contributions_count_last_year: 2553,
    avatar_url: "https://avatars.githubusercontent.com/u/47848?v=4",
    github_url: "https://github.com/rafaelfranca",
    organization: "Shopify",
    location: "Ottawa, ON",
    short_code: "PgqecT"
  },
  {
    name: "Aaron Patterson",
    nickname: "tenderlove",
    followers_count: "9.5k",
    following_count: "27",
    stars_count: "242",
    contributions_count_last_year: 715,
    avatar_url: "https://avatars.githubusercontent.com/u/3124?v=4",
    github_url: "https://github.com/tenderlove",
    organization: "@Shopify",
    location: "Seattle",
    short_code: "MFYgE2"
  },
  {
    name: "Eileen M. Uchitelle",
    nickname: "eileencodes",
    followers_count: "3.1k",
    following_count: "17",
    stars_count: "211",
    contributions_count_last_year: 370,
    avatar_url: "https://avatars.githubusercontent.com/u/1080678?v=4",
    github_url: "https://github.com/eileencodes",
    organization: "Shopify",
    location: "13:29\n  (UTC -05:00)",
    short_code: "izBCGg"
  },
  {
    name: "José Valim",
    nickname: "josevalim",
    followers_count: "15.4k",
    following_count: "11",
    stars_count: "32",
    contributions_count_last_year: 3257,
    avatar_url: "https://avatars.githubusercontent.com/u/9582?v=4",
    github_url: "https://github.com/josevalim",
    organization: "@dashbitco",
    location: "Kraków, Poland",
    short_code: "t5bFKt"
  },
  {
    name: "David Heinemeier Hansson",
    nickname: "dhh",
    followers_count: "20.7k",
    following_count: "0",
    stars_count: "17",
    contributions_count_last_year: 1412,
    avatar_url: "https://avatars.githubusercontent.com/u/2741?v=4",
    github_url: "http://github.com/dhh",
    organization: "37signals",
    location: nil,
    short_code: "zSCqvS"
  }
]

profiles.each do |profile_attrs|
  Profile.find_or_create_by!(github_url: profile_attrs[:github_url]) do |profile|
    profile.assign_attributes(profile_attrs)
  end
end

puts "✅ Perfis criados com sucesso!"
