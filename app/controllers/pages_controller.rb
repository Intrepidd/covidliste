class PagesController < ApplicationController
  before_action :set_counters, only: [:home]

  def home
    @user = User.new(birthdate: Date.today.change(year: 1961))
  end

  def benevoles
    @volunteers = Volunteer.where(anon: false).order(sort_name: :asc) + Volunteer.where(anon: true).order(sort_name: :asc)
  end

  def contact
    @contact_items = FaqItem.where(category: "Collaboration et contact")
  end

  def presse
  end

  def mentions_legales
  end

  def privacy
  end

  def algorithme
    @faq_item = FaqItem.find_by(title: "Comment fonctionne la sélection des volontaires ?")
  end

  def faq
    @faq_items = FaqItem.where(area: "main")
  end

  def faq_pro
    @faq_items = FaqItem.where(area: "pro")
  end

  def robots
    render "pages/robots", layout: false, content_type: "text/plain"
  end

  StaticPage.all.each do |page|
    page_slug = page.slug.underscore

    define_method page_slug do
      page_slug_as_string = page_slug.to_s

      case page_slug_as_string
      when "cookies"
        @meta_title = "Notre politique liées aux cookies"
      when "mentions_legales"
        @meta_title = "Mentions légales - Covidliste"
      when "cgu_volontaires"
        @meta_title = "CGU - Volontaires - Covidliste"
      when "cgu_pro"
        @meta_title = "CGU - Professionnels de santé - Covidliste"
      when "privacy_volontaires"
        @meta_title = "Protection des données - Volontaires - Covidliste"
      when "privacy_pro"
        @meta_title = "Protection des données - Professionnels de santé - Covidliste"
      end

      @body = page.body
      render "pages/static"
    end
  end

  private

  def set_counters
    @users_count = Rails.cache.fetch(:users_count, expires_in: 5.minutes) { User.count }
    @confirmed_matched_users_count = Rails.cache.fetch(:confirmed_matched_users_count, expires_in: 5.minutes) { Match.confirmed.count }
    @matched_users_count = Rails.cache.fetch(:matched_users_count, expires_in: 5.minutes) { Match.distinct.count("user_id") + Match.confirmed.count }
    @vaccination_centers_count = Rails.cache.fetch(:vaccination_centers_count, expires_in: 5.minutes) { VaccinationCenter.confirmed.count }
  end

  def skip_pundit?
    true
  end
end
