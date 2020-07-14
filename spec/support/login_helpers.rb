# frozen_string_literal: true

module LoginHelpers
  module System
    def login_user(name)
      visit "/" unless current_path == "/"
      page.driver.browser.manage.add_cookie(
        name: :uid,
        value: [name, Nanoid.generate(size: 3)].join("/"),
        domain: CAPYBARA_COOKIE_DOMAIN
      )
    end

    def logout() = page.driver.clear_cookies
  end

  module Controller
    def login(user)
      @request.session.merge! user.attributes.slice("id", "name")
    end
  end
end

RSpec.configure do |config|
  config.include LoginHelpers::System, type: :system
  config.include LoginHelpers::Controller, type: :controller

  config.before(:each, type: :system) do |ex|
    unless ex.metadata[:auth] == false
      login_user "Any"
    end
  end
end
