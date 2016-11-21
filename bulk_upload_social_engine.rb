# Agregue un mejor soporte para debugging
require 'pry'
require 'pry-byebug'

# Agregue también soporte para entrar en modo debugging automatico en caso que salten excepciones:

require 'pry-rescue'
require 'pry-stack_explorer'

# Agregue soporte de pry para la Rails Console
# require 'pry-rails'

  #Agregue colores y formateo a las salidas de la rails console
require 'awesome_print'

require "json"
require "selenium-webdriver"
require "rspec"
include RSpec::Expectations

# binding.pry

describe "SubirFotos" do

  before(:each) do
    @driver = Selenium::WebDriver.for :chrome
    @base_url = "http://aweb.socialengine.com"
    @accept_next_alert = true
    @driver.manage.timeouts.implicit_wait = 30
    @verification_errors = []
  end

  after(:each) do
    @driver.quit
    @verification_errors.should == []
  end

  it "test_subir_fotos" do
    @driver.get(@base_url + "/")
    @driver.find_element(:id, "sign-in-email").clear
    @driver.find_element(:id, "sign-in-email").send_keys "somemail@mail.com"
    @driver.find_element(:id, "sign-in-password").clear
    @driver.find_element(:id, "sign-in-password").send_keys "somepassword"
    @driver.find_element(:xpath, "//button[@type='submit']").click

    i = 1
    array = Dir.entries("/home/s/borrala/Pampa2015/")
    array.delete_at 0 # saco el "."
    array.delete_at 0 # saco el ".."
    tamanio = array.count

    array[5..tamanio].each do |archivo|
      # Boton +
      # @driver.find_element(:link, "Post").click
      # @driver.find_element(:name, "image-title").clear
      # binding.pry
      @driver.find_element(:xpath, "//*[@id='menu_user']/div[3]/a").click

      @driver.find_element(:name, "image-title").send_keys "Pampa 2015, foto #{i}"

      # @driver.find_element(:name, "image-file").clear
      # @driver.find_element(:name, "image-file").click
      #i @driver.find_element(:link, "upload a photo").click
      @driver.find_element(:name, "image-file").send_keys "/home/s/borrala/Pampa2015/#{archivo}"

      @driver.find_element(:css, "button.btn.btn-primary").click
      # @driver.find_element(:css, "span.profile-link-displayname").click

      sleep 8 #por el efecto javascript choto

      i = i + 1

      sleep 40 # para no saturar
    end # fin array

  end

  def element_present?(how, what)
    @driver.find_element(how, what)
    true
  rescue Selenium::WebDriver::Error::NoSuchElementError
    false
  end

  def alert_present?()
    @driver.switch_to.alert
    true
  rescue Selenium::WebDriver::Error::NoAlertPresentError
    false
  end

  def verify(&blk)
    yield
  rescue ExpectationNotMetError => ex
    @verification_errors << ex
  end

  def close_alert_and_get_its_text(how, what)
    alert = @driver.switch_to().alert()
    alert_text = alert.text
    if (@accept_next_alert) then
      alert.accept()
    else
      alert.dismiss()
    end
    alert_text
  ensure
    @accept_next_alert = true
  end
end
