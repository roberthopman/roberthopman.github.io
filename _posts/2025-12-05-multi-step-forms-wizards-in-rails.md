---
layout: post
title: "Multi-Step Forms (Wizards) in Rails"
date: 2025-12-05
tags: [ruby, rails, forms, wizard, wicked]
description: A summary of implementing multi-step forms in Rails covering data persistence, URL strategies, model validations, and controller patterns.
---

This is a summary of [Rails Wizards Part 1-5](https://jonsully.net/blog/rails-wizards-part-one) by Jon Sullivan.

## What is a Wizard and Why Do We Need It?

Many apps have multiple steps to complete a task:
- Onboarding / signup
- Filling out tax forms
- Insurance claims
- Invoice generation
- Mortgage/loan applications

Multi-step forms (wizards) make these flows manageable.

**Scope:**
- Server side information management
- Focus on saving information to a single model or database table
- Each step fills out some subset of attributes on that model

**Acceptance Criteria:**
- DRY code for maintainability
- Each step usable via browser and API endpoint with correct feedback
- User experience considerations:
  - Can the user stop and resume later?
  - Can the user work through two instances in different tabs?
  - Can the user jump between steps?

## Data Persistence Strategies

Three options:
1. **Session persistence** - Generally avoid this
2. **Database persistence** - Use when wizard progress is part of your domain model
3. **Cache persistence** - Use when wizard progress is not part of your domain model

## URL Strategies

**ID/Key-in-URL:**

Database:
```ruby
object/:id/steps/:step_name
```

Cache:
```ruby
object/p1rsn93/steps/:step_name
```

**ID/Key-in-Session:**
```ruby
object/wizard/steps/:step_name
```

## Model Validations

The goal is to validate each step against its subset of fields while maintaining capability to validate the whole object.

Example scaffold:
```ruby
rails g scaffold House address exterior_color interior_color current_family_last_name rooms:integer square_feet:integer
```

The model uses an enum to define form steps and context-specific validators: `required_for_step?` is a helper method to determine if the current step is required based on the form step. `with_options` is a Rails helper method to group validations by context.

```ruby
# app/models/house.rb
class House < ApplicationRecord
  enum form_steps: {
    address_info: [:address, :current_family_last_name],
    house_info: [:interior_color, :exterior_color],
    house_stats: [:rooms, :square_feet]
  }

  attr_accessor :form_step

  with_options if: -> { required_for_step?(:address_info) } do
    validates :address, presence: true, length: { minimum: 10, maximum: 50 }
    validates :current_family_last_name, presence: true, length: { minimum: 2, maximum: 30 }
  end

  with_options if: -> { required_for_step?(:house_info) } do
    validates :interior_color, presence: true
    validates :exterior_color, presence: true
  end

  with_options if: -> { required_for_step?(:house_stats) } do
    validates :rooms, presence: true, numericality: { gt: 1 }
    validates :square_feet, presence: true
  end

  def required_for_step?(step)
    return true if form_step.nil?

    ordered_keys = self.class.form_steps.keys.map(&:to_sym)
    ordered_keys.index(step) <= ordered_keys.index(form_step)
  end
end
```

## Routes and Controllers

Use a separate controller per wizard (e.g., `app/controllers/steps_controllers/house_steps_controller.rb`). The examples below use the [wicked gem](https://github.com/zombocom/wicked).

### 1. Database Persistence + In-URL Routing

Routes:
```ruby
resources :houses do
  resources :steps, only: [:show, :update], controller: 'steps_controllers/house_steps'
end
# URLs: /houses/1/steps/address_info
```

Houses controller:
```ruby
class HousesController < ApplicationController
  def new
    @house = House.new
    @house.save!(validate: false)
    redirect_to house_step_path(@house, House.form_steps.keys.first)
  end
end
```

Steps controller:
```ruby
module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      @house = House.find(params[:house_id])
      render_wizard
    end

    def update
      @house = House.find(params[:house_id])
      @house.assign_attributes(house_params)
      render_wizard @house
    end

    private

    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      house_path(@house)
    end
  end
end
```

View template:
```erb
<!-- app/views/steps_controllers/house_steps/address_info.html.erb -->

<%= form_with model: @house, url: wizard_path do |f| %>
  <% if f.object.errors.any? %>
    <div class="error_messages">
      <% f.object.errors.full_messages.each do |error| %>
        <p><%= error %></p>
      <% end %>
    </div>
  <% end %>

  <fieldset>
    <legend>Address Info</legend>

    <div>
      <%= f.label :address %>
      <%= f.text_field :address %>
    </div>

    <div>
      <%= f.label :current_family_last_name %>
      <%= f.text_field :current_family_last_name %>
    </div>

    <div>
      <%= f.submit 'Next Step' %>
    </div>
  </fieldset>
<% end %>
```

The `.permit(House.form_steps[step])` trick ensures users can't inject attributes not meant for the current step.

### 2. Database Persistence + In-Session Routing

For prettier URLs:

Routes:
```ruby
resources :houses
resources :build_house, only: [:show, :update], controller: 'steps_controllers/house_steps'
# URLs: /build_house/address_info
```

Houses controller:
```ruby
class HousesController < ApplicationController
  def new
    unless house_id = session[:house_id]
      @house = House.new
      @house.save!(validate: false)
      session[:house_id] = @house.id
    end
    redirect_to build_house_path(House.form_steps.keys.first)
  end
end
```

Steps controller:
```ruby
module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      @house = House.find(session[:house_id])
      render_wizard
    end

    def update
      @house = House.find(session[:house_id])
      @house.assign_attributes(house_params)
      render_wizard @house
    end

    private

    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      house_path(@house)
    end
  end
end
```

### 3. Cache Persistence + In-URL Routing

Note: Enable Rails cache for local development with `rails dev:cache`.

Routes:
```ruby
resources :houses
resources :build_house, only: [] do
  resources :step, only: [:update, :show], controller: 'steps_controllers/house_steps'
end
# URLs: /build_house/abc-xyz/steps/address_info
```

Houses controller:
```ruby
class HousesController < ApplicationController
  def new
    house_builder_key = SecureRandom.urlsafe_base64(6)
    Rails.cache.fetch(house_builder_key) { Hash.new }
    redirect_to build_house_step_path(house_builder_key, House.form_steps.keys.first)
  end
end
```

For `Rails.cache.fetch(house_builder_key) { Hash.new }`: If the key exists in the cache, it returns the stored value. If the key doesn't exist in the cache, it executes the block { Hash.new } which creates a new empty hash, stores it in the cache with the given key, and returns it. So fetch either returns the stored value or the new empty hash.


Steps controller:
```ruby
module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      # If the key exists in the cache, it returns the stored value. If the key doesn't exist in the cache, it returns nil
      house_attrs = Rails.cache.read(params[:build_house_id])
      @house = House.new(house_attrs)
      render_wizard
    end

    def update
      # It reads the cache, merges the house_params, and writes the result back to the cache
      house_attrs = Rails.cache.read(params[:build_house_id]).merge(house_params)
      @house = House.new(house_attrs)

      if @house.valid?
        Rails.cache.write(params[:build_house_id], house_attrs)
        redirect_to_next next_step
      else
        render_wizard
      end
    end

    private

    # Only allow the params for specific attributes allowed in this step. 
    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      house_attrs = Rails.cache.read(params[:build_house_id])
      @house = House.new house_attrs
      # end of the wizard we save the house to the database
      @house.save!
      # delete the cache
      Rails.cache.delete params[:build_house_id]
      # redirect to the house path
      house_path(@house)
    end
  end
end
```

In our cache-based wizard:

- We're creating a new House object in each step with House.new(house_attrs)
- This object is not persisted to the database until the very end of the wizard
- Therefore, form_with would default to POST, which is incorrect for our wizard flow

For cache-based wizards, explicitly set the form method to PATCH since the object isn't persisted until the very end of the wizard:

```erb
<%= form_with model: @house, url: wizard_path, method: :patch do |f| %>
  <%# form fields... %>
<% end %>
```

### 4. Cache Persistence + In-Session Routing

Routes:
```ruby
resources :houses
resources :build_house, only: [:update, :show], controller: 'steps_controllers/house_steps'
# URLs: /build_house/address_info
```

Houses controller:
```ruby
class HousesController < ApplicationController
  def new
    Rails.cache.fetch(session.id) { Hash.new }
    redirect_to build_house_path(House.form_steps.keys.first)
  end
end
```

Steps controller:
```ruby
module StepsControllers
  class HouseStepsController < ApplicationController
    include Wicked::Wizard

    steps *House.form_steps.keys

    def show
      house_attrs = Rails.cache.read(session.id)
      @house = House.new(house_attrs)
      render_wizard
    end

    def update
      house_attrs = Rails.cache.read(session.id).merge(house_params)
      @house = House.new(house_attrs)

      if @house.valid?
        Rails.cache.write(session.id, house_attrs)
        redirect_to_next next_step
      else
        render_wizard
      end
    end

    private

    def house_params
      params.require(:house).permit(House.form_steps[step]).merge(form_step: step.to_sym)
    end

    def finish_wizard_path
      house_attrs = Rails.cache.fetch(session.id)
      @house = House.new(house_attrs)
      @house.save!
      Rails.cache.delete(session.id)
      house_path(@house)
    end
  end
end
```

For the full series with more details, visit [jonsully.net/blog/rails-wizards-part-one](https://jonsully.net/blog/rails-wizards-part-one).


