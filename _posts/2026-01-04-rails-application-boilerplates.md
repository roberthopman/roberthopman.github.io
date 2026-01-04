---
layout: post
title: "Rails application boilerplates"
tags: [ruby, rails]
---

## Open source

- [mattbrictson/nextgen](https://github.com/mattbrictson/nextgen)
- [excid3/gorails-app-template](https://github.com/excid3/gorails-app-template)
- [bullet-train-co/bullet_train](https://github.com/bullet-train-co/bullet_train)
- [yshmarov/moneygun](https://github.com/yshmarov/moneygun)
- [tarunvelli/rails-tabler-starter](https://github.com/tarunvelli/rails-tabler-starter)
- [rootstrap/rails_api_base](https://github.com/rootstrap/rails_api_base)
- [shakacode/react_on_rails](https://github.com/shakacode/react_on_rails)
- [lewagon/rails-templates](https://github.com/lewagon/rails-templates)
- [alec-c4/kickstart](https://github.com/alec-c4/kickstart)
- [ryanckulp/speedrail](https://github.com/ryanckulp/speedrail)
- [ackama/rails-template](https://github.com/ackama/rails-template)
- [ralixjs/rails-ralix-tailwind](https://github.com/ralixjs/rails-ralix-tailwind)

## Paid

- [Jumpstart Rails](https://jumpstartrails.com/)
- [Business Class Kit](https://businessclasskit.com/)
- [Lightning Rails](https://lightningrails.com/)

## Common features

After analyzing multiple Rails boilerplates, these are the minimal features they all share:

| Feature | Common Choice | Notes |
| --- | --- | --- |
| Authentication | Devise | Often with OmniAuth for social logins |
| Authorization | Pundit | Role-based access control |
| Testing | RSpec | With FactoryBot, system specs |
| Code Quality | RuboCop | Plus ERB linting, Brakeman |
| Background Jobs | Sidekiq/Solid Queue | Async processing |
| CSS Framework | Tailwind CSS | Some use Bootstrap |
| Security Scanning | Brakeman | Static analysis |
| Deployment | Multiple | Render, Heroku, Fly.io, Kamal |

Most boilerplates also include:
- Multi-tenancy (teams/organizations)
- Stripe payment integration
- GitHub Actions CI/CD
- Modern frontend (Hotwire/Turbo)
