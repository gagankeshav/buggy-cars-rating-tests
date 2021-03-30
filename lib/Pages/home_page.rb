class HomePage

  def initialize(driver)
    @driver = driver
    @wait = Selenium::WebDriver::Wait.new(timeout: 60)
  end

  # UI Elements in the format of how and what as expected by Selenium
  ELEMENTS = {'register_button' => [:xpath, "//a[contains(@class, 'btn-success') and text() = 'Register']"],
              'login_field' => [:name, "login"],
              'password_field' => [:name, "password"],
              'login_button' => [:xpath, "//button[contains(@class, 'btn-success') and text() = 'Login']"],
              'profile_link' => [:xpath, "//a[contains(@class, 'nav-link') and text() = 'Profile']"],
              'logout_link' => [:xpath, "//a[contains(@class, 'nav-link') and text() = 'Logout']"],
              'salutation' => [:xpath, "//span[contains(@class, 'nav-link') and contains(text(), 'Hi')]"],
              'category_list' => [:xpath, "//img[contains(@class, 'center-block')]"]}

  def click_register_button
    wait_for_element('register_button').click
  end

  def enter_username(username=nil)
    wait_for_element('login_field').send_keys username
  end

  def enter_password(password=nil)
    wait_for_element('password_field').send_keys password
  end

  def click_login_button
    wait_for_element('login_button').click
  end

  def login_to_app(username=nil, password=nil)
    enter_username(username)
    enter_password(password)
    click_login_button
  end

  def click_logout_button
    wait_for_element('logout_link').click
  end

  def get_salutation_text
    wait_for_element('salutation').text
  end

  def open_category(category_title=nil)
    @wait.until { find_elements('category_list').length > 1 }
    categories = find_elements('category_list')
    case category_title
      when 'Popular Make'
        categories[0].click
      when 'Popular Model'
        categories[1].click
      when 'Overall Rating'
        categories[2].click
    end
  end

  def wait_for_element(element)
    @wait.until { find_element(element) }
  end

  def is_visible(element)
    @wait.until { find_element(element).displayed? }
  end

  def find_element(element)
    @driver.find_element(ELEMENTS[element][0], ELEMENTS[element][1])
  end

  def find_elements(element)
    @driver.find_elements(ELEMENTS[element][0], ELEMENTS[element][1])
  end

end