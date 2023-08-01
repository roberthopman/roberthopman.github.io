---
layout: post
title:  "Enter a debugging session when test run fails"
---

Using:
- Capybara - https://github.com/teamcapybara/capybara
- Cuprite - https://github.com/rubycdp/cuprite

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

When a line in this code fails, the execution halts at debug. In order to explore context a screenshot was also taken before that:
```rb
  test 'the happy path' do
    begin
      visit new_user_path
      fill_in 'user_name', with: 'John Doe'
      fill_in 'user_email', with: 'john.doe@example.com'
      click_button 'Create User'
      assert_content 'User was successfully created'
    rescue StandardError => e
      pp e.backtrace.inspect
      take_screenshot
      debug(binding)
    end
  end
```

**Note:** halting execution to enter debug mode may not be desired or even possible in a production environment, especially in continuous integration or other automated environments.
