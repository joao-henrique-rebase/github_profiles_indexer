require 'rails_helper'

RSpec.describe "Profiles search", type: :system do
  fixtures :profiles

  context "when the search returns results" do
    it "displays the matching profiles" do
      visit profiles_path

      fill_in "Buscar por nome, usuário, organização, localização...", with: profiles(:one).name

      expect(page).to have_content(profiles(:one).name)
      expect(page).to have_content("@#{profiles(:one).nickname}")
      expect(page).to have_link("/#{profiles(:one).short_code}")
      expect(page).not_to have_content(profiles(:two).name)
    end
  end

  context "when the search returns no results" do
    it "displays a message indicating no profiles were found" do
      visit profiles_path

      fill_in "Buscar por nome, usuário, organização, localização...", with: "Developer SuperHero"

      expect(page).to have_content("Nenhum perfil encontrado.")
    end
  end
end
