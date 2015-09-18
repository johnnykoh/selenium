
class TestData

	def self.get_base_url
		{
			"production" => "https://direct.tfehotels.sabredemos.com",
			"staging" => "http://staging.tfehotels.sabredemos.com"
		}[self.get_environment]
	end
	
	def self.get_environment
		ENV['environment'] || "staging"
	end
	
end