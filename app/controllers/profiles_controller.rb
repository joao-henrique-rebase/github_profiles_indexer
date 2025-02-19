class ProfilesController < ApplicationController
  before_action :set_profile, only: [:edit, :update, :show, :destroy, :rescan]

  def index
    @profiles = if params[:query].blank?
                  Profile.all
                else
                  Profile.where("name ILIKE :query OR nickname ILIKE :query OR organization ILIKE :query OR location ILIKE :query", 
                                query: "%#{params[:query]}%")
                end

    respond_to do |format|
      format.html
      format.text { render partial: "profiles/list", locals: { profiles: @profiles }, formats: [:html] }
    end
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    if @profile.save
      result = update_data_from_github(@profile)

      if result[:status] == :success
        redirect_to @profile, notice: "Perfil criado com sucesso."
      else
        @profile.destroy
        redirect_to new_profile_path, alert: result[:message]
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      result = update_data_from_github(@profile)

      if result[:status] == :success
        redirect_to @profile, notice: "Perfil atualizado com sucesso."
      else
        redirect_to edit_profile_path(@profile), alert: result[:message]
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @profile.destroy
    redirect_to profiles_path, notice: "Perfil removido com sucesso."
  end

  def show
    respond_to do |format|
      format.html
      format.text { render partial: "profiles/show_profile", locals: { profile: @profile }, formats: [:html] }
    end
  end

  def rescan
    result = update_data_from_github(@profile)
    if result[:status] == :success
      render json: { status: "success", message: result[:message] }
    else
      render json: { status: "error", message: result[:message] }, status: :unprocessable_entity
    end
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
      { status: :success, message: "Perfil atualizado com sucesso!" }
    rescue GithubScraper::ScraperError => e
      Rails.logger.error "Erro no Scraper: #{e.message}"
      { status: :error, message: "Erro no Scraper: #{e.message}" }
    end
  end
end
