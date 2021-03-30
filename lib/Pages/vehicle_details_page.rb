class VehicleDetailsPage

  def initialize(driver)
    @driver = driver
  end

  # UI Elements in the format of how and what as expected by Selenium
  ELEMENTS = { 'comment_field' => [:id, "comment"],
               'vote_button' => [:xpath, "//button[contains(@class, 'btn-success') and text() = 'Vote!']"],
               'vote_confirmation' => [:class, "card-text"],
               'vote_count'=> [:xpath, "//div[contains(@class, 'card-block')]/h4/strong"],
               'branding_header' => [:xpath, "//a[contains(@class, 'navbar-brand') and text() = 'Buggy Rating']"]}

  def enter_comment(comment=nil)
    wait_for_element('comment_field').send_keys comment
  end

  def click_vote_button
    wait_for_element('vote_button').click
  end

  def get_vote_count
    wait_for_element('vote_count').text.to_i
  end

  def get_voted_message
    wait_for_element('vote_confirmation').text
  end

  def get_to_home_page
    wait_for_element("branding_header").click
  end

  def wait_for_element(element)
    wait = Selenium::WebDriver::Wait.new(timeout: 60)
    wait.until { find_element(element) }
  end

  def find_element(element)
    @driver.find_element(ELEMENTS[element][0], ELEMENTS[element][1])
  end
end