require 'rubygems'
require 'selenium-webdriver'
require 'test/unit'
require 'date'
require File.join(File.dirname(__FILE__), 'test_data')
require File.join(File.dirname(__FILE__), 'helper')

class TFEHotels_ReservationsConsole < Test::Unit::TestCase

	def setup
		@browser = Selenium::WebDriver.for(:firefox)
		@browser.manage.timeouts.implicit_wait = 10
	end
	
	def teardown
		@browser.quit
	end

	def test_reservationsconsole
		@browser.get(TestData.get_base_url)
		check_console_displaying
		simple_console_query
	end
	
	private
	
	#Basic interactive methods
	def assert_element_text(name, text, strategy=:id)
		failure_info = "Element '#{name}' is showing text '#{@browser.find_element(strategy, name).text}', which is different from '#{text}'"
		assert(@browser.find_element(strategy, name).text.include?(text), failure_info)
	end
	
	def assert_element_displaying(name, strategy=:id)
		assert(@browser.find_element(strategy, name).displayed?)
	end
	
	def click_element(name, strategy=:link_text)
		wait_for_animation
		@browser.find_element(strategy, name).click
		wait_for_ajax
	end
	
	def wait_for_ajax
		Selenium::WebDriver::Wait.new(:timeout => 30).until do
			sleep 1
			@browser.execute_script("return jQuery.active") == 0
		end
	end
	
	def wait_for_animation
		Selenium::WebDriver::Wait.new(:timeout => 30).until do
			sleep 1
			@browser.execute_script("return jQuery(':animated').length") == 0
		end
	end
	
	def two_days_later
		day = Date.today.mday
		return day+2
	end
	
	#Functional testing methods
	def check_console_displaying
		assert_element_displaying("reservations-console")
		assert_element_text("Select a destination", "Select a destination", :link_text)
		assert_element_text("location-select2", "Select a hotel")
		assert_element_text("rooms", "Rooms")
		assert_element_text("adults", "Adults")
		assert_element_text("child", "Child<12 yrs")
	end
	
	def simple_console_query
		click_element("Select a destination")
		click_element("Auckland")
		assert_element_text("location-select2", "Rendezvous Auckland")
		click_element("arrival-f", :id)
		click_element(two_days_later)
		click_element("submit", :class)
		assert_element_text("V111_C6_PropertyNameLabel", "Rendezvous Hotel Auckland")
	end
end