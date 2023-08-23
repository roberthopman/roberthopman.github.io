---
layout: post
title:  "Enter a debugging session when test run fails"
---

Using:
- Cuprite - https://github.com/rubycdp/cuprite
- Capybara - https://github.com/teamcapybara/capybara
- Minitest - https://github.com/minitest/minitest


In a local development environment, when a line in this code fails, the execution stops:

```rb
class MainFeaturesTest < ApplicationSystemTestCase
  test 'the happy path' do
    visit new_user_path
    fill_in 'user_name', with: 'John Doe'
    fill_in 'user_email', with: 'john.doe@example.com'
    click_button 'Create User'
    assert_content 'User was successfully created'
  end
end
```

When a line in the next file fails, the execution halts at debug. In order to explore context, the rele a screenshot was also taken before that.

We run this with `DEBUG_TESTS=true rails test test/system/main_features_test.rb:2`:

```rb
class MainFeaturesTest < ApplicationSystemTestCase
  test 'debug' do
    return if ENV['DEBUG_TESTS'].nil?
    
    begin
      test_the_happy_path
    rescue StandardError => e
      relevant_backtrace = e.backtrace.select { |line| line.include?('/test/') }
      pp relevant_backtrace
      take_screenshot
      debug(binding)
    end
  end

  test 'the happy path' do
    visit new_user_path
    fill_in 'user_name', with: 'John Doe'
    fill_in 'user_email', with: 'john.doe@example.com'
    click_button 'Create User'
    assert_content 'User was successfully created'
  end
end
```

**Note:** halting execution to enter debug mode may not be desired or even possible in a production environment, especially in continuous integration or other automated environments.


Besides the above, and more relevant, you want to be enabled to log:
- Database transactions
- Browser events

## Database transactions

In `application_record.rb`:
```
  before_save :log_info, if: :testing_environment?

  private

  def log_info
    puts "Saving record: #{self.do_something}"
  end

  def testing_environment?
    Rails.env.test?
  end
```

## Browser events:

Was curious which browser events could be happening:

https://developer.mozilla.org/en-US/docs/Web/Events

Let's see the titles:

let tbody = document.querySelector('tbody');
let results = Array.from(tbody.querySelectorAll('tr')).map(row => Array.from(row.querySelectorAll('td')).map(td => td.textContent));
console.log(results.map(arr => arr[0])); 
console.log(results); 

```
['Animation', 'Asynchronous data fetching', 'Clipboard', 'Composition', 'CSS transition', 'Database',
'DOM mutation', "Drag'n'drop, Wheel", 'Focus', 'Form', 'Fullscreen', 'Gamepad', 'Gestures', 'History',
'HTML element content display management', 'Inputs', 'Keyboard', 'Loading/unloading documents',
'Manifests', 'Media', 'Messaging', 'Mouse', 'Network/Connection', 'Payments', 'Performance', 'Pointer',
'Print', 'Promise rejection', 'Sockets', 'SVG', 'Text selection', 'Touch', 'Virtual reality',
'RTC (real time communication)', 'Server-sent events', 'Speech', 'Workers']
```

Examples of ferrum console loggers:
- https://github.com/rubycdp/cuprite/issues/113#issuecomment-753609213
- https://github.com/bullet-train-co/bullet_train/blob/main/test/support/ferrum_console_logger.rb
