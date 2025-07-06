---
layout: post
title: "General Production Checklist for Automating Applications"
---

This is a concept checklist to ensure that an application is production ready.

[The gist at github.](https://gist.github.com/roberthopman/fdeeb94e74b7c6b7e67857916f241714)

## Hosting
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

## Monitoring
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

## Logging
  * Rotation
  * Collection 
  * Retention
  * Size
  * Types
      * Server
      * Cron
      * Error
      * Other

## SSL
  * Domains 
  * Renewal procedure
      * Access provision
      * Automatic

## Application Checklist
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

## Domain names & DNS
  * List 
  * Access
  * Payment 

## Transactional Email
  * Payment processing	

## 3rd party integrations, services, plugins, themes, assets, images, fonts
  * List
  * Access
  * Payment 

## Development Checklist
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

## Coordination Checklist
  * Shared knowledge in directories, or files
  * Work locations, times and schedules for real-time conversation
  * Access to communication; Slack, Email, Telephone
