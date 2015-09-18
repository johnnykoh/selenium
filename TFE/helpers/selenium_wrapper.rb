require 'selenium-webdriver'

class SeleniumWrapper
  def initialize(browser = :firefox, mobile = false)
    profile = Selenium::WebDriver::Firefox::Profile.new
    #profile["network.proxy.type"]          = 1
    #profile["network.proxy.http"]          = "127.0.0.1"
    #profile["network.proxy.http_port"]     = 9999
    #profile["network.proxy.no_proxies_on"] = "localhost, 127.0.0.1, *awful-valentine.com"
	profile["general.useragent.override"] = "iPhone" if mobile
    @browser = Selenium::WebDriver.for(browser, :profile => profile)
  end  
  
  def quit
     @browser.quit
  end
  
  def wait_for_ajax
    Selenium::WebDriver::Wait.new(:timeout => 60).until do
      sleep 1
      @browser.execute_script("return jQuery.active") == 0
    end                
  end
  
  def wait_for_animation
    Selenium::WebDriver::Wait.new(:timeout => 60).until do
      sleep 1
      @browser.execute_script("return jQuery(':animated').length") == 0
    end                
  end 
  
  def wait_for_ajax_and_animation
    if jQuery_defined?
      wait_for_ajax
      wait_for_animation
    end
  end    
  
  def type_text(text, element, strategy=:id)
    begin 
     bring_current_window_to_front
     clear(element, strategy)
     find_element(element, strategy).send_keys(text)
     wait_for_ajax_and_animation
    rescue Exception => e
      puts "Attempt to type '#{text}' into '#{element}' with strategy '#{strategy}' has failed"
      screenshot
      raise e
    end
  end
  
  def click(element, strategy=:link)
    begin
     bring_current_window_to_front
     find_element(element, strategy).click
     wait_for_ajax_and_animation
    rescue Exception => e
      puts "Attempt to click the #{element} with strategy '#{strategy}' has failed"
      screenshot
      raise e
    end
  end
  
  def get_inner_text(element, strategy=:id)
     find_element(element, strategy).text
  end 
  
  def clear(element, strategy=:id)
    begin
      find_element(element, strategy).clear
    rescue Exception => e
      puts "Attempt to clear the #{element} has failed"
      screenshot
      raise e
    end
  end
  
  def find_element(element, strategy=:id) 
    @browser.find_element(strategy, element)
  end
  
  def bring_current_window_to_front
     @browser.switch_to.window(@browser.window_handles.first)
  end
  
  def screenshot
    screenshot_location = "images/#{Time.now.to_i}.png"
    puts "Screnshot of the WebPage can be found here #{screenshot_location}"
    @browser.save_screenshot(screenshot_location)
  end
  
  def current_url
    @browser.current_url
  end
  
  def get(url)
    @browser.get(url)
  end  
  
  def jQuery_defined?
    @browser.execute_script("return typeof jQuery == 'function'")
  end
  
end