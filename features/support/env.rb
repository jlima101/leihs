require 'rubygems'
require 'fileutils'

# IMPORTANT: This file is generated by cucumber-rails - edit at your own peril.
# It is recommended to regenerate this file in the future when you upgrade to a
# newer version of cucumber-rails. Consider adding your own code to a new file
# instead of editing this one. Cucumber will automatically load all features/**/*.rb
# files.

require 'cucumber/rails'
require 'rack_session_access/capybara'

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

# Capybara defaults to XPath selectors rather than Webrat's default of CSS3. In
# order to ease the transition to Capybara we set the default here. If you'd
# prefer to use XPath just remove this line and adjust any selectors in your
# steps to use the XPath syntax.
Capybara.default_selector = :css

# By default, any exception happening in your Rails application will bubble up
# to Cucumber so that your scenario will fail. This is a different from how
# your application behaves in the production environment, where an error page will
# be rendered instead.
#
# Sometimes we want to override this default behaviour and allow Rails to rescue
# exceptions and display an error page (just like when the app is running in production).
# Typical scenarios where you want to do this is when you test your error pages.
# There are two ways to allow Rails to rescue exceptions:
#
# 1) Tag your scenario (or feature) with @allow-rescue
#
# 2) Set the value below to true. Beware that doing this globally is not
# recommended as it will mask a lot of errors for you!
#
ActionController::Base.allow_rescue = false

##################################################################################

require 'selenium/webdriver'

Capybara.register_driver :selenium_phantomjs do |app|
  Capybara::Selenium::Driver.new app, browser: :phantomjs
end

Capybara.register_driver :selenium_firefox do |app|
  if ENV['FIREFOX_ESR_PATH'].present?
    Selenium::WebDriver::Firefox.path = ENV['FIREFOX_ESR_PATH']
  end
  profile = Selenium::WebDriver::Firefox::Profile.new
  Capybara::Selenium::Driver.new app, browser: :firefox, profile: profile
end

Capybara.register_driver :selenium_chrome do |app|
  Capybara::Selenium::Driver.new app, browser: :chrome
end

##################################################################################

Before('@personas') do
  @use_personas = true
end

Before('@ldap') do
  ENV['TMPDIR'] = File.join(Rails.root, 'tmp')
  # TODO: Move this out to something that runs *before* the test suite itself?
  unless File.exist?(ENV['TMPDIR'])
    Dir.mkdir(ENV['TMPDIR'])
  end
  Setting::LDAP_CONFIG = File.join(Rails.root, 'features', 'data', 'LDAP_generic.yml')
  @ldap_server = Ladle::Server.new(
    port: 12345,
    ldif: File.join(Rails.root, 'features', 'data', 'ldif', 'generic.ldif'),
    domain: 'dc=example,dc=org'
  )
  @ldap_server.start
end

Before('@javascript') do
  @use_phantomjs = true
end

Before('@browser', '@firefox') do
  @use_browser = :firefox
end

Before('@browser', '@chrome') do
  @use_browser = :chrome
end

Before('@browser') do
  @use_browser = case ENV['BROWSER']
                   when '0'
                     false
                   when 'chrome'
                     :chrome
                   when 'firefox'
                     :firefox
                   else
                     @use_browser || ENV['DEFAULT_BROWSER'].try(:to_sym) || :firefox
                 end
end

Before('~@browser') do
  @use_browser = case ENV['BROWSER']
                   when 'chrome'
                     :chrome
                   when 'firefox'
                     :firefox
                   else
                     false
                 end
end

Before('~@generating_personas') do
  if @use_browser
    case @use_browser
      when :firefox
        Capybara.current_driver = :selenium_firefox
      when :chrome
        Capybara.current_driver = :selenium_chrome
    end
    page.driver.browser.manage.window.maximize # to prevent Selenium::WebDriver::Error::MoveTargetOutOfBoundsError: Element cannot be scrolled into view
  elsif @use_phantomjs
    Capybara.current_driver = :selenium_phantomjs
  end

  Cucumber.logger.info "Current capybara driver: %s\n" % Capybara.current_driver

  Dataset.restore_random_dump(@use_personas ? 'normal' : 'minimal')
end

##################################################################################

After('@ldap') do
  @ldap_server.stop
end
