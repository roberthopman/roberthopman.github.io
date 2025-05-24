---
layout: post
title:  "Questions for maintenance with checklist"
---

**Questions for maintenance**

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


<details>
  <summary>General Checklist</summary>
  <div markdown=1>

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


Finally, see the article on [how to upgrade ruby on rails]({% post_url 2023-01-01-how-to-upgrade-a-ruby-on-rails-application %}).