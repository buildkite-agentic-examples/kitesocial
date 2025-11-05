Capybara.configure do |config|
  config.server = :puma, { Silent: true }
end

# Configure headless Chrome for system tests
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument('--headless')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')
  options.add_argument('--disable-gpu')
  options.binary = '/usr/bin/chromium' if File.exist?('/usr/bin/chromium')

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end
