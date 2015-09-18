
class TestData

	def self.get_base_url
		{
			"production" => "https://direct.tfehotels.com",
			"staging" => "http://staging.tfehotels.sabredemos.com"
		}[self.get_environment]
	end
	
	def self.get_environment
		print "\nStarting the tests in #{ENV['environment']}.\n"
		ENV['environment'] || "staging"
	end
	
end