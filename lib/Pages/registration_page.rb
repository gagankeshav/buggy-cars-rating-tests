class RegistrationPage

  def initialize(driver)
    @driver = driver
  end

  # UI Elements in the format of how and what as expected by Selenium
  ELEMENTS = { 'login_field' => [:id, "username"],
               'firstname_field' => [:id, "firstName"],
               'lastname_field' => [:id, "lastName"],
               'password_field' => [:id, "password"],
               'confirm_password_field' => [:id, "confirmPassword"],
               'register_button' => [:xpath, "//button[contains(@class, 'btn-default') and text() = 'Register']"],
               'cancel_button' => [:xpath, "//a[contains(@class, 'btn') and text() = 'Cancel']"],
               'registration_alert' => [:xpath, "//*[contains(@class, 'result alert')]"],
               'branding_header' => [:xpath, "//a[contains(@class, 'navbar-brand') and text() = 'Buggy Rating']"]}

  def enter_username(username=nil)
    wait_for_element('login_field').send_keys username
  end

  def enter_firstname(firstname=nil)
    wait_for_element('firstname_field').send_keys firstname
  end

  def enter_lastname(lastname=nil)
    wait_for_element('lastname_field').send_keys lastname
  end

  def enter_password(password=nil)
    wait_for_element('password_field').send_keys password
  end

  def enter_confirm_password(confirm_password=nil)
    wait_for_element('confirm_password_field').send_keys confirm_password
  end

  def click_register_button
    wait_for_element('register_button').click
  end

  def click_cancel_button
    wait_for_element('cancel_button').click
  end

  def register_new_user(user_details=nil)
    enter_username(user_details.fetch('username'))
    enter_firstname(user_details.fetch('firstname'))
    enter_lastname(user_details.fetch('lastname'))
    enter_password(user_details.fetch('password'))
    enter_confirm_password(user_details.fetch('confirm_password'))
    click_register_button
  end

  def get_alert_text
    wait_for_element('registration_alert').text
  end

  def get_to_home_page
    wait_for_element("branding_header").click
  end

  def wait_for_element(element)
    wait = Selenium::WebDriver::Wait.new(timeout: 60)
    wait.until { find_element(element) }
  end

  alias is_visible wait_for_element

  def find_element(element)
    @driver.find_element(ELEMENTS[element][0], ELEMENTS[element][1])
  end
end