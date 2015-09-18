
class MobileReservationsConsoleTests < Test::Unit::TestCase

	def setup
		@selenium = SeleniumWrapper.new(:firefox, true)
	end
	
	def teardown
		@selenium.quit
	end

	def test_mobile_reservation_console
		print "\ntest_mobile_reservation_console test started.\n"
		
		@selenium.get(TestData.get_base_url)
		@selenium.click("li#tab-book-now a", :css)
		@selenium.click("Select a destination")
		@selenium.click("Auckland")
		@selenium.click("submit", :class)
		assert_equal("Rendezvous Hotel Auckland", @selenium.get_inner_text("HeaderName"))
		
		print "\ntest_mobile_reservation_console test ended.\n"
	end
	
	private
	
	#Basic interactive methods
	def two_days_later
		day = Date.today.mday
		if day < 27
			return day+2
		else
			return day-26
		end
	end
end