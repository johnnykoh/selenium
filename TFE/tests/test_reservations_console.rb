
class ReservationsConsoleTests < Test::Unit::TestCase

	def setup
		@selenium = SeleniumWrapper.new
	end
	
	def teardown
		@selenium.quit
	end

	def test_reservation_console
		print "\ntest_reservation_console test started.\n"
		
		@selenium.get(TestData.get_base_url)
		assert(@selenium.find_element("reservations-console").displayed?)
		@selenium.click("Select a destination")
		@selenium.click("Auckland")
		assert_equal("Rendezvous Auckland", @selenium.get_inner_text("location-select2"))
		@selenium.click("arrival-f", :id)
		@selenium.click(two_days_later)
		@selenium.click("submit", :class)
		assert_equal("Rendezvous Hotel Auckland", @selenium.get_inner_text("V111_C6_PropertyNameLabel"))
		
		print "\ntest_reservation_console test ended.\n"
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