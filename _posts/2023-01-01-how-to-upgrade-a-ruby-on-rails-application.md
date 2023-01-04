---
layout: post
title:  "How to upgrade a Ruby on Rails application?"
---

As the Ruby on Rails guides say: "Before attempting to upgrade an existing application, you should be sure you have a good reason to upgrade. You need to balance several factors: the need for new features, the increasing difficulty of finding support for old code, and your available time and skills, to name a few." <https://guides.rubyonrails.org/upgrading_ruby_on_rails.html>

Start with the goal. Keep it simple. The goal must be: 
1. solving a (commercial) problem and must be easy to understand
2. organised in such a way that there is confidence in reaching the desired end state.

Assume you're not the only one working on the application, communicate the goal and the steps to upgrade the application. We assume there are a handful of critical business processes that are enabled by the application, not just a website. 

Example goal could be: Secure the continuity of the critical business processes.

From here on, we'll limit the scope to the technical part: upgrading the application.

Production parts to be considered:
- server
- database
- schema
- ruby version
- rails version
- gem versions
- branche
- deployment

Next, the steps to upgrade the application:
- for now, out of scope are upgrading the server and database version. 
- for a quick pulse, assess if upgrading the gems is possible via: <https://railsbump.org/> for an overview of rails versions and their compatibility with ruby versions: <https://www.fastruby.io/blog/ruby/rails/versions/compatibility-table.html>
- assuming there are a range of tools that enable or block upgrading, such as: automated tests, test coverage, continuous integration, application code security vulnerability analysis, code best practices checking and code style consistency rules.
- assuming the handful of critical business processes are covered by tests, which they are usually not, run the tests. There might be some failures. 
- if the tests are not covering the handful of critical business processes, run the application manually and test the handful of critical business processes manually. Decide for additional tests if needed.
- upgrade the Ruby version. Could be in small steps or big steps, depending on factors. Use rbenv/RVM/asdf to manage multiple ruby versions, download the version, change version in the Gemfile, and run `bundle update`.
- again, run necessary checks, like the test suite and/or manually test the handful of critical business processes.
- upgrade the Rails version, test the application doesn't work anymore as required for the handful of critical business processes. Implicitly, this means you need to fix it.
- upgrade or downgrade gems, as required and read the (depreciation) messages afterwards on the command line, even if there are no explicit warnings.
- run the `rails app:update`: "This will help you with the creation of new files and changes of old files in an interactive session." <https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#the-update-task>
- Have an acceptance environment to deploy and explore results, and a rollback plan.
- Finally, there will a deploy to production. 

Resources for the upgrade process:
- <https://www.ruby-lang.org/en/downloads/branches/>
- <https://railsbump.org/>
- <https://railsdiff.org/> and <https://github.com/railsdiff/railsdiff>
- <https://makandracards.com/makandra/59328-how-to-upgrade-rails-workflow-advice>
- <https://infinum.com/handbook/rails/workflows/rails-upgrades>
- <https://www.fastruby.io/blog/rails/upgrade/rails-upgrade-series.html> 
- <https://rormaas.com/maintenance.html#our-maintenance-process>
- <https://jeromezng.com/work/research-and-development/engineering/development/upgrading-rails>
- <http://www.t27duck.com/posts/8-how-i-upgrade-ruby-on-rails>
- <https://github.com/jwo/rails-upgrade_checklist/blob/master/app/views/pages/list.markdown>
- <https://railsapps.github.io/updating-rails.html>
- Dual booting: <https://github.com/fastruby/next_rails> and <https://github.com/shopify/bootboot>