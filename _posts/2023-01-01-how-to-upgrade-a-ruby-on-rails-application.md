---
layout: post
title:  "How to upgrade a Ruby on Rails application?"
excerpt: "Step-by-step guide for upgrading Rails apps covering Ruby versions, gems, testing strategies, and managing the upgrade process with your team."
last_modified_at: 2025-12-13
tags: [ruby, rails, upgrade, maintenance, testing, deployment]
---

First, we'll limit the scope to the technical part: upgrading the application.

Production parts to be considered which could impact the upgrade of the application:
- server
- database
- schema
- ruby version
- rails version
- gem versions
- branch
- deployment

For now, out of scope are upgrading the server and database version. 

Next, the steps to upgrade the application:
- Assess if upgrading the gems is possible via: <https://railsbump.org/> for an overview of rails versions and their compatibility with ruby versions: <https://www.fastruby.io/blog/ruby/rails/versions/compatibility-table.html>
- Assume there are a range of tools that enable or block upgrading, such as: automated tests, test coverage, continuous integration, application code security vulnerability analysis, code best practices checking and code style consistency rules.
- Assume the handful of critical business processes are covered by tests. They are usually not, so run the tests. Detect failures early and often. 
- If the tests are not covering the handful of critical business processes, run the application manually and test the handful of critical business processes manually. Think about happy paths, edge cases, and error handling. Decide for additional tests if needed.
- Parts that could be considered:
  - Web application
  - Mobile application
  - API endpoints
  - Background jobs or tasks
    - Manual
    - Scheduled
  - Middleware
  - Supporting pages like: admin dashboard, status page

- Upgrade the Ruby version. Could be in small steps or big steps, depending on factors. Use rbenv/RVM/asdf to manage multiple ruby versions, download the version, change version in the Gemfile, and run `bundle update`.
- Run necessary checks, like the test suite and/or manually test the handful of critical business processes.
- Upgrade the Rails version, test the application doesn't work anymore as required for the handful of critical business processes. Implicitly, this means you need to fix it.

From the Rails upgrade guide [https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#ruby-versions):

| Rails Version      | Required Ruby Version    |
|--------------------|-------------------------|
| Rails 8.0, 8.1     | Ruby 3.2.0 or newer     |
| Rails 7.2          | Ruby 3.1.0 or newer     |
| Rails 7.0, 7.1     | Ruby 2.7.0 or newer     |
| Rails 6            | Ruby 2.5.0 or newer     |
| Rails 5            | Ruby 2.2.2 or newer     |

It could go in this order (Source: <https://github.com/rubyforgood/awbw/issues/3>):
```
[ ]  Upgrade Ruby to 2.7.x
[ ]  Upgrade Rails 5.0 -> 5.1
[ ]  Upgrade Rails 5.1 -> 5.2
[ ]  Upgrade to Ruby 3.0.x
[ ]  Upgrade to Rails 5.2 -> 6.0
[ ]  Upgrade Rails 6.0 -> 6.1
[ ]  Upgrade Ruby 3.3.x
[ ]  Upgrade Rails 6.1 -> 7.0
[ ]  Upgrade Rails 7.0 -> 7.1
[ ]  Upgrade Ruby to 3.4.x
[ ]  Upgrade Rails 8.0
```

- Upgrade or downgrade gems, as required and read the (depreciation) messages afterwards on the command line, even if there are no explicit warnings (<https://thoughtbot.com/blog/upgrade-rails-6-to-rails-7>)
- Run the `rails app:update`: "This will help you with the creation of new files and changes of old files in an interactive session." <https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#the-update-task>
- Have an acceptance environment to deploy and explore results, and a rollback plan.
- Finally, there will be a deploy to production. 

Resources for the upgrade process:
- <https://www.ruby-lang.org/en/downloads/branches/>
- <https://railsbump.org/>
- <https://railsdiff.org/> and <https://github.com/railsdiff/railsdiff>
- <https://makandracards.com/makandra/59328-how-to-upgrade-rails-workflow-advice>
- <https://infinum.com/handbook/rails/workflows/rails-upgrades>
- <https://www.fastruby.io/blog/rails/upgrade/rails-upgrade-series.html>
- <https://rormaas.com/maintenance.html#our-maintenance-process>
- <http://www.t27duck.com/posts/8-how-i-upgrade-ruby-on-rails>
- <https://github.com/jwo/rails-upgrade_checklist/blob/master/app/views/pages/list.markdown>
- <https://railsapps.github.io/updating-rails.html>
- <https://web.archive.org/web/20240725023959/https://jeromezng.com/work/research-and-development/engineering/development/upgrading-rails>
- Dual booting: <https://github.com/fastruby/next_rails> and <https://github.com/shopify/bootboot>
- <https://thoughtbot.com/blog/upgrade-rails-6-to-rails-7>


# Non-technical

Management of integrating the upgrade process with the team is the other part of the process.

As the Ruby on Rails guides [say](https://guides.rubyonrails.org/upgrading_ruby_on_rails.html): 


> Before attempting to upgrade an existing application, you should be sure you have a good reason to upgrade. You need to balance several factors: the need for new features, the increasing difficulty of finding support for old code, and your available time and skills, to name a few.

Start with the goal. Keep it simple. The goal must be: 
1. solving a (commercial) problem and must be easy to understand
2. organised in such a way that there is confidence in reaching the desired end state.

The goal is the starting point for the upgrade process.
- Assume there are a handful of critical business processes that are enabled by the application, not just a website
- Assume you're not the only one working on the application
- Communicate the goal
- Communicate the steps to upgrade the application. 

Example goal could be: Secure the continuity of the critical business processes.

Finally, read how to [balance maintenance and development]({% post_url 2023-09-22-how-to-balance-maintenance-and-development %}).