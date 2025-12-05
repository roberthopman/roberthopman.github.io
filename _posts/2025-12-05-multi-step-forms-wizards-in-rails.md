---
layout: post
title: "Multi-Step Forms (Wizards) in Rails"
date: 2025-12-05
tags: [ruby, rails, forms, wizard, wicked]
description: A summary of implementing multi-step forms in Rails covering data persistence, URL strategies, model validations, and controller patterns.
---

## What is a multi-step form (wizard) and why do we need it?

Starting with a summary of [Rails Wizards Part 1-5](https://jonsully.net/blog/rails-wizards-part-one) by Jon Sullivan. This is a great introduction to multi-step forms in Rails. Then we'll look at different approaches to implement them in Rails.

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

## Data persistence strategies

Three options:
1. **Session persistence** - Generally avoid this
2. **Database persistence** - Use when wizard progress is part of your domain model
3. **Cache persistence** - Use when wizard progress is not part of your domain model

## URL strategies

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

## Model validations

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

## Routes and controllers

Use a separate controller per wizard (e.g., `app/controllers/steps_controllers/house_steps_controller.rb`). The examples below use the [wicked gem](https://github.com/zombocom/wicked).

### 1. Database persistence + in-URL routing

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

### 2. Database persistence + in-session routing

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

### 3. Cache persistence + in-URL routing

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

### 4. Cache persistence + in-session routing

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


## The implementation of cache persistence without the Wicked gem

Then an implementation using cache persistence + in-URL routing without the Wicked gem. This approach gives you full control over the wizard flow.

Source: [multi-step-form commit 49a365c](https://github.com/roberthopman/multi-step-form/commit/49a365c48c95a6d62e8b9228928eb81f4b90847b)

### Sequence diagram

```
┌───────┐          ┌──────────┐          ┌───────┐          ┌──────┐
│Browser│          │Controller│          │ Cache │          │Model │
└───┬───┘          └────┬─────┘          └───┬───┘          └──┬───┘
    │                   │                    │                 │
    │ GET /houses/new   │                    │                 │
    │──────────────────>│                    │                 │
    │                   │                    │                 │
    │                   │ generate cache_key │                 │
    │                   │ write({})          │                 │
    │                   │───────────────────>│                 │
    │                   │                    │                 │
    │  redirect /build_house/:key/steps/address_info           │
    │<──────────────────│                    │                 │
    │                   │                    │                 │
    │ GET /build_house/:key/steps/address_info                 │
    │──────────────────>│                    │                 │
    │                   │                    │                 │
    │                   │ read(cache_key)    │                 │
    │                   │───────────────────>│                 │
    │                   │   house_attrs      │                 │
    │                   │<───────────────────│                 │
    │                   │                    │                 │
    │                   │ House.new(attrs)   │                 │
    │                   │─────────────────────────────────────>│
    │                   │      @house        │                 │
    │                   │<─────────────────────────────────────│
    │                   │                    │                 │
    │   render show     │                    │                 │
    │<──────────────────│                    │                 │
    │                   │                    │                 │
    │ PATCH (form data) │                    │                 │
    │──────────────────>│                    │                 │
    │                   │                    │                 │
    │                   │ read(cache_key)    │                 │
    │                   │───────────────────>│                 │
    │                   │   house_attrs      │                 │
    │                   │<───────────────────│                 │
    │                   │                    │                 │
    │                   │ merge(params)      │                 │
    │                   │ House.new(attrs)   │                 │
    │                   │─────────────────────────────────────>│
    │                   │      @house        │                 │
    │                   │<─────────────────────────────────────│
    │                   │                    │                 │
    │                   │ @house.valid?      │                 │
    │                   │─────────────────────────────────────>│
    │                   │      true          │                 │
    │                   │<─────────────────────────────────────│
    │                   │                    │                 │
    │                   │ write(key, attrs)  │                 │
    │                   │───────────────────>│                 │
    │                   │                    │                 │
    │                   │ [if final_step?]   │                 │
    │                   │ @house.save        │                 │
    │                   │─────────────────────────────────────>│
    │                   │                    │                 │
    │                   │ delete(cache_key)  │                 │
    │                   │───────────────────>│                 │
    │                   │                    │                 │
    │  redirect         │                    │                 │
    │<──────────────────│                    │                 │
```

### Model

The model defines form steps and conditional validations:

```ruby
# app/models/house.rb
class House < ApplicationRecord
  FORM_STEPS = {
    address_info: [:address, :current_family_last_name],
    house_info: [:interior_color, :exterior_color],
    house_stats: [:rooms, :square_feet]
  }.freeze

  attr_accessor :form_step

  with_options if: -> { required_for_step?(:address_info) } do
    validates :address, presence: true, length: { minimum: 5, maximum: 50 }
    validates :current_family_last_name, presence: true, length: { minimum: 2, maximum: 30 }
  end

  with_options if: -> { required_for_step?(:house_info) } do
    validates :interior_color, presence: true
    validates :exterior_color, presence: true
  end

  with_options if: -> { required_for_step?(:house_stats) } do
    validates :rooms, presence: true, numericality: { greater_than: 1 }
    validates :square_feet, presence: true
  end

  def required_for_step?(step)
    return true if form_step.nil?

    ordered_keys = self.class::FORM_STEPS.keys.map(&:to_sym)
    !!(ordered_keys.index(step) <= ordered_keys.index(form_step))
  end
end
```

### Routes

```ruby
# config/routes.rb
resources :houses

resources :build_house, only: [] do
  resources :steps, only: [:show, :update], controller: "steps_controllers/house_steps" do
    member do
      get :back
    end
  end
end
```

### Houses controller

Initiates the wizard by generating a cache key:

```ruby
# app/controllers/houses_controller.rb
class HousesController < ApplicationController
  before_action :set_house, only: %i[show edit update destroy]

  def index
    @houses = House.all
  end

  def show
  end

  def new
    house_cache_key = "house_form_#{session.id}_#{Random.urlsafe_base64(6)}"
    Rails.cache.write(house_cache_key, {}, expires_in: 1.hour)
    redirect_to build_house_step_path(house_cache_key, House::FORM_STEPS.keys.first)
  end

  # edit, create, update, destroy...

  private

  def set_house
    @house = House.find(params.expect(:id))
  end

  def house_params
    params.expect(house: [:address, :exterior_color, :interior_color,
                          :current_family_last_name, :rooms, :square_feet])
  end
end
```

### Steps controller

Handles form navigation and validation:

```ruby
# app/controllers/steps_controllers/house_steps_controller.rb
module StepsControllers
  class HouseStepsController < ApplicationController
    before_action :set_house_cache_key
    before_action :load_house_from_cache

    STEPS = House::FORM_STEPS.keys.freeze

    def show
      @current_step = params[:id].to_sym
      @step_index = STEPS.index(@current_step)
      @total_steps = STEPS.length

      unless STEPS.include?(@current_step)
        redirect_to build_house_step_path(@house_cache_key, STEPS.first)
      end
    end

    def update
      @current_step = params[:id].to_sym
      @step_index = STEPS.index(@current_step)
      @total_steps = STEPS.length

      # Load existing data and merge with new params
      house_attrs = Rails.cache.read(@house_cache_key) || {}
      house_attrs = house_attrs.merge(house_params)

      @house = House.new(house_attrs)
      @house.form_step = @current_step

      if @house.valid?
        Rails.cache.write(@house_cache_key, house_attrs, expires_in: 1.hour)

        if final_step?
          @house.form_step = nil
          if @house.save
            Rails.cache.delete(@house_cache_key)
            redirect_to house_path(@house), notice: "House was successfully created."
          else
            render :show, status: :unprocessable_entity
          end
        else
          next_step = STEPS[STEPS.index(@current_step) + 1]
          redirect_to build_house_step_path(@house_cache_key, next_step)
        end
      else
        render :show, status: :unprocessable_entity
      end
    end

    def back
      @current_step = params[:id].to_sym
      previous_step_index = STEPS.index(@current_step) - 1

      if previous_step_index >= 0
        previous_step = STEPS[previous_step_index]
        redirect_to build_house_step_path(@house_cache_key, previous_step)
      else
        redirect_to houses_path
      end
    end

    private

    def set_house_cache_key
      @house_cache_key = params[:build_house_id] || generate_cache_key
    end

    def generate_cache_key
      "house_form_#{session.id}_#{Random.urlsafe_base64(6)}"
    end

    def load_house_from_cache
      house_attrs = Rails.cache.read(@house_cache_key) || {}
      @house = House.new(house_attrs)
    end

    def house_params
      allowed_fields = House::FORM_STEPS[@current_step] || []
      params.expect(house: [*allowed_fields]).merge(form_step: @current_step)
    end

    def final_step?
      @current_step == STEPS.last
    end
  end
end
```

### Helper

```ruby
# app/helpers/houses_helper.rb
module HousesHelper
  def step_title(step)
    case step.to_sym
    when :address_info
      "Address Information"
    when :house_info
      "House Information"
    when :house_stats
      "House Statistics"
    else
      "Unknown Step"
    end
  end

  def step_button_text(step)
    if step.to_sym == House::FORM_STEPS.keys.last
      "Complete House"
    else
      "Continue"
    end
  end

  def first_step?(current_step = nil)
    step = current_step || @current_step
    step == House::FORM_STEPS.keys.first
  end

  def last_step?(current_step = nil)
    step = current_step || @current_step
    step == House::FORM_STEPS.keys.last
  end
end
```

### Views

Main show template:

```erb
<!-- app/views/steps_controllers/house_steps/show.html.erb -->
<div class="house-wizard-container">
  <%= turbo_frame_tag "wizard_step" do %>
    <div class="progress-bar-container">
      <div class="progress-bar">
        <div class="progress-fill" style="width: <%= ((@step_index + 1) * 100.0 / @total_steps).round(1) %>%"></div>
      </div>
      <p class="progress-text">Step <%= @step_index + 1 %> of <%= @total_steps %></p>
    </div>

    <div class="step-content">
      <h2><%= step_title(@current_step) %></h2>

      <%= form_with model: @house,
            url: build_house_step_path(@house_cache_key, @current_step),
            method: :patch,
            data: {
              controller: "multi-step-form",
              turbo_frame: last_step? ? "_top" : "wizard_step"
            },
            class: "wizard-form" do |f| %>

        <% if @house.errors.any? %>
          <div class="error-messages">
            <% @house.errors.full_messages.each do |error| %>
              <p class="error"><%= error %></p>
            <% end %>
          </div>
        <% end %>

        <%= render "steps_controllers/house_steps/#{@current_step}", form: f %>

        <div class="form-actions">
          <% unless first_step? %>
            <%= link_to "Back",
                  back_build_house_step_path(@house_cache_key, @current_step),
                  class: "btn btn-secondary" %>
          <% end %>

          <%= f.submit step_button_text(@current_step), class: "btn btn-primary" %>
        </div>
      <% end %>
    </div>
  <% end %>
</div>
```

Step partial:

```erb
<!-- app/views/steps_controllers/house_steps/_address_info.html.erb -->
<fieldset>
  <legend>Address Information</legend>

  <div class="form-group">
    <%= form.label :address %>
    <%= form.text_field :address, placeholder: "Enter your full address" %>
  </div>

  <div class="form-group">
    <%= form.label :current_family_last_name, "Family Last Name" %>
    <%= form.text_field :current_family_last_name %>
  </div>
</fieldset>
```

### Observations

This implementation works, but has some issues:

1. **Model pollution**: The `House` model contains wizard-specific logic (`FORM_STEPS`, `form_step`, `required_for_step?`)
2. **Controller complexity**: Navigation logic (`next_step`, `previous_step`, `final_step?`) lives in the controller
3. **Scattered concerns**: Step definitions, validations, and navigation are spread across model and controller. This makes it difficult to test and maintain.

---

## Improvement: extract to a form object

Considering the issues with the Model + Controller approach, let's extract the wizard logic to a Form Object. This is a more Rails-y way to handle multi-step forms.

Source: [multi-step-form commit c0523d5](https://github.com/roberthopman/multi-step-form/commit/c0523d5117b8f93ea0f698d3e548b3b0b9ef8985)


### What changes?

| Before (Model + Controller)         | After (Form Object) |
|-------------------------------------|-----------------------|
| `FORM_STEPS` in model               | `FORM_STEPS` in form object |
| `form_step` attr_accessor in model  | `form_step` attribute in form object |
| `required_for_step?` in model       | `required_for_step?` in form object |
| Step validations in model           | Step validations in form object |
| Navigation methods in controller    | Navigation methods in form object |
| `House.new(house_attrs)`            | `House::MultiStepHouseForm.from_cache(cache_data)` |
| `@house.valid?`                     | `@form.valid?` |

### Model (now clean)

The model now only contains data integrity validations:

```ruby
# app/models/house.rb
class House < ApplicationRecord
  validates :address, presence: true, length: { minimum: 10, maximum: 50 }
  validates :current_family_last_name, presence: true, length: { minimum: 2, maximum: 30 }
  validates :interior_color, presence: true
  validates :exterior_color, presence: true
  validates :rooms, presence: true, numericality: { greater_than: 1 }
  validates :square_feet, presence: true, numericality: { greater_than: 0 }
end
```

### Base form class

```ruby
# app/forms/application_form.rb
class ApplicationForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Validations

  # For form_with compatibility
  def persisted?
    false
  end

  def to_key
    nil
  end

  def to_param
    nil
  end

  def model_name
    ActiveModel::Name.new(self.class, nil, self.class.name.demodulize.gsub(/Form$/, ""))
  end
end
```

### Form object

The form object handles step definitions, validations, navigation, and persistence:

```ruby
# app/forms/house/multi_step_house_form.rb
class House::MultiStepHouseForm < ApplicationForm
  FORM_STEPS = {
    address_info: [:address, :current_family_last_name],
    house_info: [:interior_color, :exterior_color],
    house_stats: [:rooms, :square_feet]
  }.freeze

  # Define all form attributes
  attribute :address, :string
  attribute :current_family_last_name, :string
  attribute :interior_color, :string
  attribute :exterior_color, :string
  attribute :rooms, :integer
  attribute :square_feet, :integer

  # Form state management
  attribute :form_step, :string
  attribute :house_id, :integer

  # Step-specific validations
  with_options if: -> { required_for_step?(:address_info) } do
    validates :address, presence: true, length: { minimum: 10, maximum: 50 }
    validates :current_family_last_name, presence: true, length: { minimum: 2, maximum: 30 }
  end

  with_options if: -> { required_for_step?(:house_info) } do
    validates :interior_color, presence: true
    validates :exterior_color, presence: true
  end

  with_options if: -> { required_for_step?(:house_stats) } do
    validates :rooms, presence: true, numericality: { greater_than: 1 }
    validates :square_feet, presence: true
  end

  def self.steps
    FORM_STEPS.keys
  end

  def self.first_step
    steps.first
  end

  def self.last_step
    steps.last
  end

  def initialize(attributes = {})
    if attributes[:house_id].present?
      house = House.find(attributes[:house_id])
      house_attrs = house.attributes.symbolize_keys.slice(*FORM_STEPS.values.flatten)
      house_attrs[:house_id] = house.id
      attributes = house_attrs.merge(attributes)
    end

    super
  end

  def form_step
    @form_step&.to_sym
  end

  def form_step=(step)
    @form_step = step&.to_sym
  end

  def current_step_fields
    FORM_STEPS[form_step] || []
  end

  def required_for_step?(step)
    return true if form_step.nil?

    ordered_keys = self.class.steps
    !!(ordered_keys.index(step) <= ordered_keys.index(form_step))
  end

  def first_step?
    form_step == self.class.first_step
  end

  def last_step?
    form_step == self.class.last_step
  end

  def next_step
    current_index = self.class.steps.index(form_step)
    return nil if current_index.nil? || current_index >= self.class.steps.length - 1

    self.class.steps[current_index + 1]
  end

  def previous_step
    current_index = self.class.steps.index(form_step)
    return nil if current_index.nil? || current_index <= 0

    self.class.steps[current_index - 1]
  end

  def step_index
    self.class.steps.index(form_step) || 0
  end

  def total_steps
    self.class.steps.length
  end

  def progress_percentage
    ((step_index + 1) * 100.0 / total_steps).round(1)
  end

  def to_cache
    {
      address: address,
      current_family_last_name: current_family_last_name,
      interior_color: interior_color,
      exterior_color: exterior_color,
      rooms: rooms,
      square_feet: square_feet,
      form_step: form_step,
      house_id: house_id
    }
  end

  def self.from_cache(cache_data)
    new(cache_data || {})
  end

  def save
    return false unless valid?

    house_attributes = {
      address: address,
      current_family_last_name: current_family_last_name,
      interior_color: interior_color,
      exterior_color: exterior_color,
      rooms: rooms,
      square_feet: square_feet
    }

    if house_id.present?
      house = House.find(house_id)
      house.update(house_attributes)
    else
      house = House.create(house_attributes)
      self.house_id = house.id if house.persisted?
    end

    house
  end

  def save!
    house = save
    raise ActiveRecord::RecordInvalid, house unless house&.persisted?

    house
  end

  def model_name
    ActiveModel::Name.new(self.class, nil, "House")
  end
end
```

### Controller

```ruby
# app/controllers/steps_controllers/house_steps_controller.rb
module StepsControllers
  class HouseStepsController < ApplicationController
    before_action :set_house_cache_key
    before_action :load_form_from_cache

    def show
      @current_step = params[:id].to_sym
      @form.form_step = @current_step

      unless House::MultiStepHouseForm.steps.include?(@current_step)
        redirect_to build_house_step_path(@house_cache_key, House::MultiStepHouseForm.first_step)
        nil
      end
    end

    def update
      @current_step = params[:id].to_sym
      @form.form_step = @current_step
      @form.assign_attributes(form_params)

      if @form.valid?
        Rails.cache.write(@house_cache_key, @form.to_cache, expires_in: 1.hour)

        if @form.last_step?
          @form.form_step = nil
          house = @form.save!
          Rails.cache.delete(@house_cache_key)
          redirect_to house_path(house), notice: "House was successfully created."
        else
          redirect_to build_house_step_path(@house_cache_key, @form.next_step)
        end
      else
        render :show, status: :unprocessable_entity
      end
    end

    def back
      @current_step = params[:id].to_sym
      @form.form_step = @current_step

      if @form.previous_step
        redirect_to build_house_step_path(@house_cache_key, @form.previous_step)
      else
        redirect_to houses_path
      end
    end

    private

    def set_house_cache_key
      @house_cache_key = params[:build_house_id] || generate_cache_key
    end

    def generate_cache_key
      "house_form_#{session.id}_#{Random.urlsafe_base64(6)}"
    end

    def load_form_from_cache
      cache_data = Rails.cache.read(@house_cache_key) || {}
      @form = House::MultiStepHouseForm.from_cache(cache_data)
    end

    def form_params
      params.expect(house: [*@form.current_step_fields])
    end
  end
end
```

### Routes

```ruby
# config/routes.rb
resources :houses

resources :build_house, only: [] do
  resources :steps, only: [:show, :update], controller: "steps_controllers/house_steps" do
    member do
      get :back
    end
  end
end
# URLs: /build_house/:cache_key/steps/:step_name
```

### Helper

```ruby
# app/helpers/houses_helper.rb
module HousesHelper
  def step_title(step)
    case step.to_sym
    when :address_info
      "Address Information"
    when :house_info
      "House Information"
    when :house_stats
      "House Statistics"
    else
      "Unknown Step"
    end
  end

  def step_button_text(step)
    if step.to_sym == House::MultiStepHouseForm.last_step
      "Complete House"
    else
      "Continue"
    end
  end
end
```

### Views

Main show template:

```erb
<!-- app/views/steps_controllers/house_steps/show.html.erb -->
<div class="house-wizard-container">
  <%= turbo_frame_tag "wizard_step" do %>
    <div class="progress-bar-container">
      <div class="progress-bar">
        <div class="progress-fill" style="width: <%= @form.progress_percentage %>%"></div>
      </div>
      <p class="progress-text">Step <%= @form.step_index + 1 %> of <%= @form.total_steps %></p>
    </div>

    <div class="step-content">
      <h2><%= step_title(@current_step) %></h2>

      <%= form_with model: @form,
            url: build_house_step_path(@house_cache_key, @current_step),
            method: :patch,
            data: {
              controller: "multi-step-form",
              turbo_frame: @form.last_step? ? "_top" : "wizard_step"
            },
            class: "wizard-form" do |f| %>

        <% if @form.errors.any? %>
          <div class="error-messages">
            <% @form.errors.full_messages.each do |error| %>
              <p class="error"><%= error %></p>
            <% end %>
          </div>
        <% end %>

        <%= render "steps_controllers/house_steps/#{@current_step}", form: f %>

        <div class="form-actions">
          <% unless @form.first_step? %>
            <%= link_to "Back",
                  back_build_house_step_path(@house_cache_key, @current_step),
                  class: "btn btn-secondary" %>
          <% end %>

          <%= f.submit step_button_text(@current_step), class: "btn btn-primary" %>
        </div>
      <% end %>
    </div>
  <% end %>
</div>
```

Step partial example:

```erb
<!-- app/views/steps_controllers/house_steps/_address_info.html.erb -->
<fieldset>
  <legend>Address Information</legend>

  <div class="form-group">
    <%= form.label :address %>
    <%= form.text_field :address, placeholder: "Enter your full address" %>
  </div>

  <div class="form-group">
    <%= form.label :current_family_last_name, "Family Last Name" %>
    <%= form.text_field :current_family_last_name, placeholder: "Enter family last name" %>
  </div>
</fieldset>
```

### Summary

| Approach | Pros | Cons |
|----------|------|------|
| Wicked gem | Less boilerplate, battle-tested | External dependency, less control |
| Model + Controller | No dependencies, straightforward | Model pollution, scattered logic |
| Form Object | Clean model, centralized logic, testable | More initial code to write |

### When to use each

- **Wicked gem**: Quick prototypes, simple wizards, when you want conventions
- **Model + Controller**: When the wizard is simple and the form object feels like overkill
- **Form Object**: Long-running apps, complex validation rules, when you want clean separation of concerns

