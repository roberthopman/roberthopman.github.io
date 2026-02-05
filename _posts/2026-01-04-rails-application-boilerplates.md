---
layout: post
title: "Rails application boilerplates"
tags: [ruby, rails]
---

## Open source

- Feb 2026 — [shakacode/react_on_rails](https://github.com/shakacode/react_on_rails)
- Feb 2026 — [alec-c4/kickstart](https://github.com/alec-c4/kickstart)
- Feb 2026 — [rootstrap/rails_api_base](https://github.com/rootstrap/rails_api_base)
- Feb 2026 — [bullet-train-co/bullet_train](https://github.com/bullet-train-co/bullet_train)
- Feb 2026 — [yshmarov/moneygun](https://github.com/yshmarov/moneygun)
- Jan 2026 — [ralixjs/rails-ralix-tailwind](https://github.com/ralixjs/rails-ralix-tailwind)
- Jan 2026 — [lewagon/rails-templates](https://github.com/lewagon/rails-templates)
- Jan 2026 — [mattbrictson/nextgen](https://github.com/mattbrictson/nextgen)
- Jan 2026 — [ackama/rails-template](https://github.com/ackama/rails-template)
- Jan 2026 — [newstler/template](https://github.com/newstler/template/tree/feature/upgrade-philosophy)
- Jan 2026 — [tarunvelli/rails-tabler-starter](https://github.com/tarunvelli/rails-tabler-starter)
- Sep 2025 — [yatish27/shore](https://github.com/yatish27/shore)
- May 2025 — [ryanckulp/speedrail](https://github.com/ryanckulp/speedrail)
- Feb 2025 — [excid3/gorails-app-template](https://github.com/excid3/gorails-app-template)
- Feb 2024 — [pch/rails-boilerplate](https://github.com/pch/rails-boilerplate)
- Oct 2023 — [hanwenzhang123/react-on-rails-boilerplate](https://github.com/hanwenzhang123/react-on-rails-boilerplate)
- Sep 2023 — [vinhmai570/rails_boilerplate](https://github.com/vinhmai570/rails_boilerplate)
- [excid3/jumpstart](https://github.com/excid3/jumpstart)
- Apr 2020 — [zarinn3pal/rails6_boilerplate](https://github.com/zarinn3pal/rails6_boilerplate)
- Jan 2019 — [mdegis/rails_boilerplate](https://github.com/mdegis/rails_boilerplate)

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
