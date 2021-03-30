class OverallRatingsPage

  def initialize(driver)
    @driver = driver
  end

  # UI Elements in the format of how and what as expected by Selenium
  ELEMENTS = { 'row' => [:xpath, "//tbody/tr[__row__]/td[__column__]"],
               'ratings_table' => [:xpath, "//table[contains(@class, 'cars table table-hover')]"]}

  # Methods to get the ratings of the vehicles from the first page
  # Once the values are received, they are stored in a hash to consume in the tests for validations
  def get_ratings
    wait_for_element('ratings_table')
    rankings = {}

    # Iterate over the table of ratings to gather relative data and create KV pairs
    for ranking in 1..5
      vehicle_details = {}
      vehicle_details['Make'] = find_element('row', [ranking.to_s,'2']).text
      vehicle_details['Model'] = find_element('row', [ranking.to_s,'3']).text
      vehicle_details['Rank'] = find_element('row', [ranking.to_s,'4']).text
      vehicle_details['Votes'] = find_element('row', [ranking.to_s,'5']).text
      vehicle_details['Engine'] = find_element('row', [ranking.to_s,'6']).text

      rankings[vehicle_details['Rank']] = vehicle_details
    end
    rankings
  end

  # Custom methods to handle dynamic waits
  def wait_for_element(element)
    wait = Selenium::WebDriver::Wait.new(timeout: 60)
    wait.until { find_element(element) }
  end

  def find_element(element, custom = nil)
    if custom
      ele = ELEMENTS[element][1].gsub(/__row__/, custom[0]).gsub(/__column__/, custom[1])
      @driver.find_element(ELEMENTS[element][0], ele)
    else
      @driver.find_element(ELEMENTS[element][0], ELEMENTS[element][1])
    end
  end
end