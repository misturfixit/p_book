require 'selenium-webdriver'
require 'test/unit'
load '../local_env.rb' if File.exist?('../local_env.rb')

class ScrollTesting < Test::Unit::TestCase

  def setup
    caps = Selenium::WebDriver::Remote::Capabilities.chrome#(chromeOptions: { args: [ "--headless" ]})  
    @driver = Selenium::WebDriver.for :chrome , desired_capabilities:caps
    @driver.manage.window.maximize
    @driver.navigate.to("http://localhost:4567")
    @wait = Selenium::WebDriver::Wait.new(:timeout => 15)
  end  

  def teardown
    sleep 10
    @driver.close
  end

  def test_scroll
      actualURL = @driver.current_url
    assert_equal('http://localhost:4567/', actualURL, 'URL Did not match')
    assert @wait.until{@driver.find_element(:xpath, '/html/body/form/input[2]').displayed?}
    assert @wait.until{@driver.find_element(:xpath, '/html/body/form/input[3]').displayed?}
    @driver.find_element(:xpath, '/html/body/a').click()
      actualURL = @driver.current_url
    assert_equal('http://localhost:4567/get_nfo', actualURL, 'URL Did not match')
    assert @wait.until{@driver.find_element(:xpath, '/html/body/form[2]/input[1]').displayed?}
    assert @wait.until{@driver.find_element(:xpath, '/html/body/form[2]/input[2]').displayed?}
    @driver.find_element(:xpath, '/html/body/form[2]/input[1]').send_keys '1234567890'
    @driver.find_element(:xpath, '/html/body/form[2]/input[2]').click()
      actualURL = @driver.current_url
    assert_equal('http://localhost:4567/return?phown=1234567890', actualURL, 'URL Did not match')
    # assert @wait.until{@driver.find_element(:xpath, '/html/body/a').displayed?}
    # assert @wait.until{@driver.find_element(:xpath, '/html/body/input').displayed?}
    @driver.find_element(:xpath, '/html/body/table/tbody/tr[2]/td[1]/input').click()
    @driver.find_element(:xpath, '//*[@id="bootawn"]').click()
  end  
end  