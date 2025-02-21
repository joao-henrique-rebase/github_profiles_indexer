require 'rails_helper'

RSpec.describe 'Profile Show', type: :system do
  fixtures :profiles

  let(:profile) { profiles(:one) }

  describe 'Accessing the show page' do
    it 'displays the profile details' do
      visit profile_path(profile)

      expect(page).to have_content(profile.name)
      expect(page).to have_content("@#{profile.nickname}")
      expect(page).to have_content("Seguidores: #{profile.followers_count}")
      expect(page).to have_content("Seguindo: #{profile.following_count}")
      expect(page).to have_content("Stars: #{profile.stars_count}")
      expect(page).to have_content("Contribuições no último ano: #{profile.contributions_count_last_year}")
      expect(page).to have_link("/#{profile.short_code}")
      expect(page).to have_button('Re-escanear')
      expect(page).to have_link('Editar', href: edit_profile_path(profile))
      expect(page).to have_button('Remover')
    end
  end

  describe 'Delete profile' do
    it 'removes the profile and updates the profiles count' do
      visit profile_path(profile)

      page.accept_alert('Tem certeza que deseja remover este perfil?') do
        click_button 'Remover'
      end

      expect(page).to have_current_path(profiles_path, wait: 1)
      expect(page).to have_content('Perfil removido com sucesso.')
    end
  end
end
