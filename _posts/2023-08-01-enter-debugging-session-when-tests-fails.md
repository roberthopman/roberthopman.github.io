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
