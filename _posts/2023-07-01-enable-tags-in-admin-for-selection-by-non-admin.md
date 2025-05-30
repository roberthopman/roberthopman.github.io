---
layout: post
title:  "Enable the admin to configure tags for selection in a dropdown, to control type and amount of tags stored"
---


Step 1: add a migration, assuming usage of `ActsAsTaggableOn` - though any `Tag` model would work. 

Adding `:archived_at` as bonus...

```rb
# frozen_string_literal: true

class CreateTagSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_settings do |t|
      t.references :tag, null: false, foreign_key: true
      t.string :target_type
      t.datetime :archived_at

      t.timestamps
    end
  end
end
```


Step 2: Design the models

```rb
class TagSetting < ApplicationRecord
  belongs_to :tag
  
  # add a scope for the target type, for example:
  scope :publications, -> { where(target_type: TARGET_TYPES.first).order(:id) }
  
  # add a scope for the active tags, for example:
  scope :active, -> { where(archived_at: nil) }
  
  attr_accessor :name

  # for flexibility the model name is not used
  TARGET_TYPES = %w[publication].freeze 

  def archive!
    update!(archived_at: Time.current)
  end

  def un_archive!
    update!(archived_at: nil)
  end

  def active
    !archived_at.present?
  end
end
```

And the `Tag` model:

```rb
class Tag < ActsAsTaggableOn::Tag
  has_many :tag_settings
end
```

Step 3: Save, update or show the relevant tag(s):

```rb
module Publications
  class TagSettingsController < ApplicationController
    before_action :set_tag_setting, only: %i[edit update show]

    def index
      @tag_settings = TagSetting.publications
    end

    def show; end

    def new
      @tag_setting = TagSetting.new
    end

    def create
      if tag_setting_params[:name].present?
        @tag = ActsAsTaggableOn::Tag.find_or_create_by!(name: tag_setting_params[:name].downcase)
        @tag_setting = TagSetting.new(tag_id: @tag.id, target_type: TagSetting::TARGET_TYPES.first)
      else
        @tag_setting = TagSetting.new
      end

      respond_to do |format|
        if @tag_setting.save
          format.html do
            redirect_to some_tag_settings_path,
                        notice: 'Publication tag was successfully created.'
          end
        else
          format.html { render :new }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        case tag_setting_params[:active]
        when '1'
          @tag_setting.un_archive!
          format.html do
            redirect_to some_tag_settings_path,
                        notice: 'Publication tag was successfully actived.'
          end
        when '0'
          @tag_setting.archive!
          format.html do
            redirect_to some_tag_settings_path,
                        notice: 'Publication tag was successfully archived.'
          end
        end
      end
    end

    private

    def set_tag_setting
      @tag_setting = TagSetting.find(params[:id])
    end

    def tag_setting_params
      params.require(:tag_setting).permit(:id, :name, :type, :active)
    end
  end
end
```
 
Step 4: Enabling to add or archive a Tag, add these in a `form.html.slim`.
I've omitted the show and index template, for brevity.

```rb
- if @tag_setting.new_record?
  = simple_form_for [:admin, @tag_setting], url: some_tag_settings_path do |f|
    = f.input :name, label: "Tag name"
    = f.button :submit, "Save", class: "btn btn-sm btn-success me-2 rounded-0", data: { turbo: false }

- else
  = simple_form_for [:admin, @tag_setting], url: some_tag_setting_path(@tag_setting) do |f|
    = f.input :name, label: "Tag name", input_html: { disabled: true, value: ActsAsTaggableOn::Tag.find(@tag_setting.tag_id) }
    = f.input :active, label: "Active", as: :boolean
    = f.button :submit, "Save", class: "btn btn-sm btn-success me-2 rounded-0", data: { turbo: false }

```

Step 5: add the below in routes.rb, to make all of the above available.

```rb
  resources :tag_settings, only: %i[index create update new edit]
```

Step 6: make them available for association with the relevant Model:

- a. Add to the MODEL: `acts_as_taggable_on :publication_tags`
- b. Add to controller: `before_action :set_tags, only: %i[new edit update]` and 

```rb
  private
    def set_tags
      @categories_collection = ActsAsTaggableOn::Tag.where(id: TagSetting.publications.active.select(:tag_id))
    end
```

- c. Add to params in controller: 

```rb
    def publication_params
      params.require(:publication).permit(:title, publication_tag_list: [])
    end
```

- d. finally, enable in the MODEL form. Please note that the `value_method` is the `:name` attribute, not the `:id`.

```rb
  = f.input :publication_tag_list, collection: @categories_collection, label: "Tags", \
      input_html: { multiple: true, value: f.object.publication_tags.join(",") },
      label_method: :name, value_method: :name
```

Summary: Overview of the feature

Add Tag:
- User can create a new tag.
- New tags appear in the tag list.

Archive Tag:
- User can archive an existing tag.
- Archived tags are hidden from the selection list.

Select Tag(s) for a Model (Publication):
- User can assign one or more tags to a model (publication) from the available tags.
- User can remove tags from a model (publication).