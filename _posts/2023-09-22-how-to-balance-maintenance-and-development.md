---
layout: post
title:  "How to balance maintenance and development?"
excerpt: "Learn how to balance maintenance and new development work with prioritization frameworks based on urgency, predictability, and impact."
tags: [maintenance, development, prioritization, workflow, best-practices]
---

The risk of only working on new development to grow the business? At some point, you will have a problem, and you need to fix it.

When you only work on new development and your strategy to fix problems is to respond when they arise, you will be able to continue to grow the business, and you will not notice the problems that are building up.

> So far no problems.

This situation can be continued for a while and average time to repair bugs will stay low.
Then there could be a point where the average time to repair bugs will increase, and the business will start to suffer. Quick fixes are tried, but don't seem to work anymore.

> Now you have a problem, and you need to fix it.

So, you need to work on maintenance and development in a balanced way. The problem is that you need to know what to work on. 

> How to know what to work on? 

First, ensure all knowledge is written down, so you can understand the business and the application. 

For example, you can create a document with the following questions:

## Maintenance and Development Questions
 
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

Then a priority list can be created, based on the answers. However, if you don't have a process to prioritize, you can use the following:

## How to prioritize?

First, decide how to prioritize. For example, you can prioritize based on the urgency (temporal status), predictability and impact. This will come back daily, as you will be reminded of negative consequences of not doing the maintenance work.

| **Category**                                      | **Temporal Status**                                                                             | **Predictability**                                                                  | **Actions** |
| ------------------------------------------------- | ----------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------- | ----------- |
| **Now (Immediate-Critical)**                      | Issue is actively occurring<br>Failure is ongoing or imminent                                   | Fully observable<br>Probability ≈ 1.0<br>No forecasting needed                      | Focus on stopping things from getting worse; Do a quick, low-cost fix to keep it safe and functioning; Record what broke and what the full solution would require |
| **Upcoming & Expected (Predictable-Critical)**    | Failure expected in days or weeks<br>Based on wear, inspections, or history                    | High confidence (P > 0.7)<br>Supported by trend data or experience                  | When important and urgent issues seem absent, evaluate and commit time to a work item in the future, for example: next week we commit to x time for work-item y |
| **Upcoming & Unexpected (Potential-Critical)**    | No current failure<br>Some early signs or weak signals<br>Could happen in weeks or months      | Low to moderate confidence (P < 0.5)<br>Based on team intuition or anomaly detection | Schedule a minor portion of time weekly for this topic; Use it to act when necessary, or to work on upcoming & expected items |

### Categories 

- **Now (Immediate-Critical)**
  - **Temporal Status**
    - Issue is actively occurring
    - Failure is ongoing or imminent
  - **Predictability**
    - Fully observable
    - Probability ≈ 1.0
    - No forecasting needed
  - **Actions**
    - Focus on stopping things from getting worse
    - Do a quick, low-cost fix to keep it safe and functioning
    - Record what broke and what the full solution would require

- **Upcoming & Expected (Predictable-Critical)**
  - **Temporal Status**
    - Failure expected in days or weeks
    - Based on wear, inspections, or history
  - **Predictability**
    - High confidence (P > 0.7)
    - Supported by trend data or experience
  - **Actions**
    - When important and urgent issues seem absent, evaluate and commit time to a work item in the future, for example: next week we commit to x time for work-item y

- **Upcoming & Unexpected (Potential-Critical)**
  - **Temporal Status**
    - No current failure
    - Some early signs or weak signals
    - Could happen in weeks or months
  - **Predictability**
    - Low to moderate confidence (P < 0.5)
    - Based on team intuition or anomaly detection
  - **Actions**
    - Schedule a minor portion of time weekly for this topic
    - Use it to act when necessary, or to work on upcoming & expected items

By now you can decide how to balance maintenance and development.