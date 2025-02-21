class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[edit update show destroy rescan]

  def index
    @profiles = params[:query].present? ? search_profiles(params[:query]) : Profile.all

    respond_to do |format|
      format.html
      format.text { render partial: 'profiles/list', locals: { profiles: @profiles }, formats: [:html] }
    end
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(profile_params)

    return render_error(:new, @profile) unless @profile.save

    result = update_data_from_github(@profile)
    if result[:status] == :success
      redirect_to @profile, notice: 'Perfil criado com sucesso.'
    else
      @profile.destroy!
      redirect_to new_profile_path, alert: result[:message]
    end
  end

  def edit; end

  def update
    return render_error(:edit, @profile) unless @profile.update(profile_params)

    result = update_data_from_github(@profile)
    if result[:status] == :success
      redirect_to @profile, notice: 'Perfil atualizado com sucesso.'
    else
      redirect_to edit_profile_path(@profile), alert: result[:message]
    end
  end

  def destroy
    @profile.destroy!
    redirect_to profiles_path, notice: 'Perfil removido com sucesso.'
  end

  def show
    respond_to do |format|
      format.html
      format.text do
        render partial: 'profiles/show_profile', locals: { profile: @profile },
               formats: [:html]
      end
    end
  end

  def rescan
    result = update_data_from_github(@profile)

    return render json: { status: 'success', message: result[:message] } if result[:status] == :success

    render json: { status: 'error', message: result[:message] }, status: :unprocessable_entity
  end

  def redirect
    profile = Profile.find_by(short_code: params[:short_code])

    return redirect_to profile.github_url, allow_other_host: true if profile

    redirect_to root_path, alert: 'Perfil não encontrado.'
  end

  private

  def set_profile
    @profile = Profile.find(params[:id])
  end

  def profile_params
    params.expect(profile: %i[name github_url])
  end

  def search_profiles(query)
    Profile.where('name ILIKE :query OR nickname ILIKE :query OR organization ILIKE :query OR location ILIKE :query',
                  query: "%#{query}%")
  end

  def update_data_from_github(profile)
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
    { status: :success, message: 'Perfil atualizado com sucesso!' }
  rescue GithubScraper::ScraperError => e
    { status: :error, message: "Erro no Scraper: #{e.message}" }
  end

  def render_error(action, profile)
    flash.now[:alert] = profile.errors.full_messages.to_sentence
    render action, status: :unprocessable_entity
  end
end
