class ProfilesController < ApplicationController
  before_action :set_profile, only: [:show, :destroy]

  def index
    @profiles = Profile.all
  end

  def show
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      update_data_from_github(@profile)
      redirect_to @profile, notice: "Perfil criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_path, notice: "Perfil removido com sucesso."
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.require(:profile).permit(:name, :github_url)
  end

  def update_data_from_github(profile)
    begin
      data = GithubScraper.call(profile.github_url)
      profile.update!(
        nickname: data[:nickname],
        avatar_url: data[:avatar_url],
        followers_count: data[:followers_count],
        following_count: data[:following_count],
        stars_count: data[:stars_count],
        contributions_count_last_year: data[:contributions],
        organization: data[:organization],
        location: data[:location]
      )
    rescue GithubScraper::ScraperError => e
      Rails.logger.error "Erro no Scraper: #{e.message}"
    end
  end
end