# Initial configuration
$LOAD_PATH.unshift File.expand_path('../../', __FILE__)
require 'helpers'

RSpec.describe "Buggy Cars Rating Tests" do

  # Loading the configuration from config.yml file
  $config = YAML.load_file(File.expand_path('../../config/config.yml', __FILE__))

  # Proceed with functional tests only if the website is available
  context "API Test" do
    it "Validate that Buggy Cars website is up" do
      response = RestClient.get($config['buggy_cars_rating_webaddress'])
      expect(response.code).to eq 200
    end
  end

  context "UI tests" do

    before(:all) do
      # Instantiating webdriver instance for chrome browser
      @driver = Selenium::WebDriver.for :chrome

      # Maximizing the browser window
      @driver.manage.window.maximize

      # Opening the Buggy Cars Rating website
      @driver.get($config['buggy_cars_rating_webaddress'])

      # Instantiating the objects for Buggy Cars Rating Application Page libraries
      @home_page = HomePage.new(@driver)
      @regn_page = RegistrationPage.new(@driver)
      @vehicle_details_page = VehicleDetailsPage.new(@driver)
      @ratings_page = OverallRatingsPage.new(@driver)

      common_password = "!P1#{Faker::Alphanumeric.alpha(number: 10)}"
      @new_user_details = {'username'=> "#{Faker::Name.unique.name.gsub(/\s.+/, '')}_#{Faker::Alphanumeric.alpha(number: 10)}",
                          'firstname'=> Faker::Name.unique.name.gsub(/.+\s/, ''),
                          'lastname'=> Faker::Name.unique.name.gsub(/\s.+/, ''),
                          'password'=> common_password,
                          'confirm_password'=> common_password}
    end

    it "Validate that user is able to register on the application" do
      # Validate that Register button is available on the Home Page
      expect(@home_page.is_visible('register_button')).to eq(true)

      @home_page.click_register_button

      # Validate that user is on the Registration Page
      expect(@driver.current_url).to eq("#{$config['buggy_cars_rating_webaddress']}register")

      @regn_page.register_new_user(@new_user_details)
      expect(@regn_page.get_alert_text).to eq($config['regn_successful_message'])
    end

    it "Validate that user is able to login to the application" do
      @home_page.login_to_app(@new_user_details.fetch('username'), @new_user_details.fetch('password'))
      aggregate_failures do
        expect(@home_page.is_visible('profile_link')).to eq(true)
        expect(@home_page.is_visible('logout_link')).to eq(true)
        expect(@home_page.get_salutation_text).to eq("Hi, #{@new_user_details.fetch('firstname')}")
      end
    end

    it "Validate that user is able to add a comment/vote for a vehicle" do
      @regn_page.get_to_home_page
      @home_page.open_category("Popular Model")
      initial_vote_count = @vehicle_details_page.get_vote_count
      @vehicle_details_page.enter_comment(Faker::Lorem.sentence)
      @vehicle_details_page.click_vote_button

      # Validate that the comment has been added
      aggregate_failures do
        expect(@vehicle_details_page.get_voted_message).to eq($config['voted_message'])
        expect(@vehicle_details_page.get_vote_count - initial_vote_count).to eq(1)
      end
    end

    it "Validate that overall ratings of vehicles are sorted based on the number of votes" do
      @vehicle_details_page.get_to_home_page
      @home_page.open_category('Overall Rating')
      ratings = @ratings_page.get_ratings
      aggregate_failures do
        expect(ratings.fetch('1').fetch('Votes').to_i > ratings.fetch('2').fetch('Votes').to_i).to eq(true)
        expect(ratings.fetch('2').fetch('Votes').to_i > ratings.fetch('3').fetch('Votes').to_i).to eq(true)
        expect(ratings.fetch('3').fetch('Votes').to_i > ratings.fetch('4').fetch('Votes').to_i).to eq(true)
        expect(ratings.fetch('4').fetch('Votes').to_i > ratings.fetch('5').fetch('Votes').to_i).to eq(true)
      end
    end

    it "Validate that a user is able to logout of the application" do
      @vehicle_details_page.get_to_home_page
      @home_page.click_logout_button
      aggregate_failures do
        expect(@home_page.is_visible('login_button')).to eq(true)
        expect(@home_page.is_visible('register_button')).to eq(true)
        expect(@home_page.is_visible('login_field')).to eq(true)
        expect(@home_page.is_visible('password_field')).to eq(true)
      end
    end

    after(:all) do
      @driver.quit
    end
  end
end
