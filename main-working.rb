require 'watir'

File.open("combo.txt", "r").each_line do |line|

  data = line.split(/\t/)
  username, gay = data.map{|d| d.split(":")[0] }.flatten
  password, gay2 = data.map{|d| d.split(":")[1] }.flatten

  puts "Username is: #{username} and Password: #{password} \n\n"
  #sleep 1

  browser = Watir::Browser.new :firefox#, headless: true
  browser.goto "https://accounts.spotify.com/sv/login/?continue=https:%2F%2Fwww.spotify.com%2Fse%2Faccount%2Foverview%2F&_locale=sv-SE"

  #Fill in form
  puts "Filling forms.."
  browser.text_field(:name => "username").set "#{username}"
  browser.text_field(:name => "password").set "#{password}"

  #Click login
  puts "Clicking button.."
  browser.button(:class => "btn btn-block btn-green ng-binding").click

  #Goto playlist and follow
  puts "Opening playlist.."
  browser.goto "https://open.spotify.com/user/nathalie0217/playlist/5daFDq0pokAzjpCDWFBoTJ?si=2jYS7vUjRi6a04bUjc_kxg" #"https://open.spotify.com/playlist/6D16nv3xj5hT1tIuzngHUX?si=usLEPF1TQJWvEn8SEzjaEw"

  puts "Checking if terms of service button is here.."

  if browser.element(:class => "terms-of-service-modal__buttons-container").exists?
    puts "ToS button found and pressed.."
    browser.div(:class => "terms-of-service-modal__buttons-container").button(:class => "btn btn-green").when_present.click
  else
  puts "No ToS button found.."
  end

  #if browser.element(:class => "AdsContainer__inner").exists?
  #  sleep 15
  #end

    if browser.div(:class => "horizontal-list tracklist-header__extra-buttons").button(:class => "btn btn-transparent btn--narrow").when_present.exists?
      puts "Following playlist.."
      browser.div(:class => "horizontal-list tracklist-header__extra-buttons").button(:class => "btn btn-transparent btn--narrow").when_present.click
      sleep 0.5
	  browser.close
    else
    browser.close
    end
end
