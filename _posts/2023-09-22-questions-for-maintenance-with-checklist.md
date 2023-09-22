---
layout: post
title:  "Questions for maintenance with checklist"
---

## Questions for maintenance

Here are five main areas with questions to ask when taking over an application for maintenance. 

1. **Application Overview and Importance**: 
   - What are the primary functions of your application?
   - How crucial is it for the business operations and revenue generation?
   - Does it integrate closely with other internal or external services and applications?

2. **Development and Maintenance**:
   - Is the application actively under development? If so, can you describe the team's size, experience, and duration of involvement with this project?
   - Do you allocate a budget specifically for its maintenance?
  
3. **Testing and Deployment**:
   - How updated is your application, and do you possess an automated update mechanism?
   - Is there a comprehensive automated test suite in place that covers essential business functions? 
   - Are there parts of the application that cause concern, and do you have the means to address these?
   - Can you describe your deployment process, including details on automation, tools, frequency, and handling of unsuccessful deployments?

4. **Infrastructure and Monitoring**:
   - How and where is your application hosted? 
   - Do you have systems like CI pipelines, staging servers, and error tracking in place? If so, could you detail the tools and processes associated with them?

5. **Workflow, Documentation, and Anomalies**:
   - How do you manage and review code changes, and what systems are in place for task tracking and backlog management?
   - Is there a structured approach to documenting the application and its domain, ensuring ease of maintenance and understanding for new team members?
   - Are there any unique or non-standard features of the application that might be relevant during maintenance tasks?


## Checklist Testing

Monitoring the health of a test suite is crucial to ensure the reliability of your application. Here are some best practices:

- **Small, Fast and Isolated Tests**: 
    - Ensure that your individual tests are small, fast and isolated from one another. Slow tests delay feedback. Tests that depend on each other can lead to false positives/negatives.
- **Test Review**: 
    - Encourage peer review of tests. A fresh pair of eyes can catch issues that the original author might have missed.
- **Test Prioritization**: 
    - Prioritize tests based on risk. High-risk areas should have more thorough testing, and lower-risk areas can have fewer tests.
- **Test Parallelization**: 
    - If applicable, parallelize your tests to speed up execution. However, ensure tests are written to be thread-safe.
- **Test Data Management**: 
    - Ensure your tests use consistent and appropriate test data. Maintain test data in a way that's easy to update and version. Lint your test data to catch errors!
- **Regular Execution**: 
    - Run your entire test suite regularly. Preferably locally and automated in the background. This could be as part of your continuous integration (CI) pipeline or on a scheduled basis. 
- **Consistent Pass Rate**: 
    - Aim for a consistent pass rate. Frequent fluctuations in pass/fail results could indicate instability in your tests or application.
- **Meaningful Failure Messages**: 
    - When a test fails, the failure message should be clear and informative, making it easier to pinpoint the issue. 
- **Monitor Flaky Tests**: 
    - Keep an eye on tests that fail sometimes (flaky tests). Investigate and address the root causes of flakiness, as they can erode trust in your test suite.
- **Code Coverage Analysis**: 
    - Monitor code coverage to ensure that a substantial portion of your codebase is covered by tests. However, aim for meaningful coverage rather than chasing 100%.
- **Alerts for Test Failures**: 
    - Set up alerts or notifications for critical test failures so that your team can respond promptly.
- **Performance Testing**: 
    - Integrate performance tests into your suite to catch performance regressions early, ensuring the application's responsiveness and scalability.
- **Documentation**: 
    - Document your test suite's purpose, test types, and how to run it. This helps new team members understand the suite's goals and structure.
- **Test Stubs and Mocks**: 
    - Use test stubs and mocks to isolate components and reduce dependencies on external systems, making tests more predictable.
- **Retrospectives**: 
    - Conduct test suite health retrospectives to identify patterns in failures, flaky tests, and other issues. Use these insights to continuously improve the suite.


## Checklist general

Production
* Hosting
    * Locations
    * Server(s)
        * Physical 
        * Cloud
    * Access to servers
        * Ip address whitelist
        * Authorization / Verification 
            * Phone
            * Email
        * Ssh
            * Authorized keys
        * Clean up old account access
    * Disk space
        * Used and free
        * Inodes used and free
        * Who can modify
        * When to modify
        * How to modify
    * File storage
    * Backups
        * Is there an automated database backup?
            * How often?
            * How long are backups kept?
            * Where are backups stored?
            * How to restore a backup?
            * How to test a backup?
        * Is there an automated file backup?
    * CDN
* Monitoring:
    * Bug/Error monitoring (Sentry)
    * Infra/Hosting monitoring (AppSignal/Elastic/...)
        * Server
        * Database
        * Redis
        * Background processing
        * Email processing
    * Other monitoring in place
        * Custom made
        * Emails
        * 3rd party tools
            * checkly, uptimerobot, pingdom, ...
            * Slack webhooks
        * Manual checks
* Logging
    * Rotation
    * Collection 
    * Retention
    * Size
    * Types
        * Server
        * Cron
        * Error
        * Other
* SSL
    * Domains 
    * Renewal procedure
        * Access provision
        * Automatic
* Application Checklist
    * Documentation for technical team
        * Description of business processes
        * Description of application
        * Deploy processes and scripts
            * For acceptance, staging, test, production
    * API
        * Are API requests being made via a separate subdomain? Api.example.com
    * Configuration is stored in environment variables?
        * Check: 
            * No Passwords in the database
            * Env variables are configured
* Domain names & DNS
    * List 
    * Access
    * Payment 
* Transactional Email
* Payment processing	
* 3rd party integrations, services, plugins, themes, assets, images, fonts

Development
* Version control
* Code reviews
* Test driven development
    * Tests all green?
    * Acceptance / integration / unit / other
    * Coverage
* Continuous integration
* Deployment 
    * Schedule monday - thursday
* Programming language
    * version
* Able to start project locally

Coordination 
* Shared knowledge in directories, or files
* Work locations, times and schedules for real-time conversation
* Access to communication; Slack, Email, Telephone


