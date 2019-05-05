require 'watir'

puts "Link to playlist you want to follow: "
playList = gets

File.open("combo.txt", "r").each_line do |line|
	
  #Open combo list and split into variables
  data = line.split(/\t/)
  username, gay = data.map{|d| d.split(":")[0] }.flatten
  password, gay2 = data.map{|d| d.split(":")[1] }.flatten

  puts "Username is: #{username} and Password: #{password}"

  #Start browser and go to login page
  browser = Watir::Browser.new :chrome, headless: false
  browser.goto "https://accounts.spotify.com/sv/login/?continue=https:%2F%2Fwww.spotify.com%2Fse%2Faccount%2Foverview%2F&_locale=sv-SE"

  #Fill in form
  puts "Filling forms.."
  browser.text_field(:name => "username").set "#{username}"
  browser.text_field(:name => "password").set "#{password}"

  #Click login
  puts "Clicking button.."
  browser.send_keys :enter
  #browser.button(:class => ["btn", "btn-block", "btn-green", "ng-binding"]).click

  #Goto playlist and follow
  sleep 0.3
  puts "Opening playlist.."
  browser.goto "#{playList}"

  browser.element(:class => "contentSpacing").present?

  #Check for ToS button
  puts "Checking if terms of service button is here.."
  if browser.element(:class => "terms-of-service-modal__buttons-container").present?
    puts "ToS button found and pressed.."
    browser.element(:class => "terms-of-service-modal__buttons-container").button(:class => ["btn", "btn-green"]).when_present.click
  else
  puts "No ToS button found.."
  end

  #Check for privacy button
  if browser.div(:class => ["btn", "btn-green"]).present?
    puts "Pressing Privacy button.."
    browser.div(:class => ["btn", "btn-green"]).click
    sleep 0.3
  end

  #Check if already following
  if browser.element(:class => "spoticon-heart-active-24").present?
    puts "Already following this user..\n"
    browser.close
    next
  end
  
  #Click follow button
  if browser.div(:class => ["horizontal-list", "tracklist-header__extra-buttons"]).button(:class => ["btn", "btn-transparent", "btn--narrow"])
	browser.div(:class => ["horizontal-list", "tracklist-header__extra-buttons"]).button(:class => ["btn", "btn-transparent", "btn--narrow"]).click
    puts "Following playlist..\n"
    sleep 0.5
	  browser.close
  else
    puts "Follow button not found, skipping\n"
    browser.close
    next
  end
end
