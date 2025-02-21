require 'rails_helper'

RSpec.describe 'Update profile', type: :system do
  fixtures :profiles

  let(:profile) { profiles(:one) }
  let(:profile_url) { 'https://github.com/dev-super-hero' }
  let(:contributions_url) { 'https://github.com/users/dev-super-hero/contributions' }

  let(:profile_html) do
    <<-HTML
      <div class="p-nickname vcard-username">dev-super-hero</div>
      <img class="avatar avatar-user" src="https://github.com/avatar/dev-super-hero.png">
      <a href="?tab=followers"><span>200</span></a>
      <a href="?tab=following"><span>150</span></a>
      <nav><a href="?tab=stars"><span class="Counter">50</span></a></nav>
      <div class="vcard-detail"><span class="p-org">Supers</span></div>
      <div class="vcard-detail"><span class="p-label">Sao Paulo, Brazil</span></div>
    HTML
  end

  let(:contributions_html) do
    <<-HTML
      <div class="js-yearly-contributions">
        <h2 class="f4">300 contributions in the last year</h2>
      </div>
    HTML
  end

  before do
    stub_request(:get, profile_url).to_return(status: 200, body: profile_html)
    stub_request(:get, contributions_url).to_return(status: 200,
                                                    body: contributions_html)
  end

  context 'when updating a profile with valid data' do
    it 'successfully updates the profile' do
      visit edit_profile_path(profile)

      fill_in 'Nome', with: 'Developer SuperHero'
      fill_in 'URL perfil do GitHub', with: 'https://github.com/dev-super-hero'

      click_button 'Salvar Perfil'

      expect(page).to have_content('Perfil atualizado com sucesso.')
      expect(page).to have_content('Developer SuperHero')
      expect(page).to have_content('dev-super-hero')
    end
  end

  context 'when updating a profile with invalid data' do
    it 'shows validation errors' do
      visit edit_profile_path(profile)

      fill_in 'Nome', with: ''
      click_button 'Salvar Perfil'

      expect(page).to have_content("Name can't be blank")
    end
  end
end
