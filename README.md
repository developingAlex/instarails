# Instarails from scratch - a VERY simple instagram clone
Created with Rails 5.1.4

This is a walkthrough of a class exercise to create an Instagram like site using rails.
## Create a new rails project

Ensure you have the appropriate prerequisites sorted for your development machine.
[The rails guide is a good resource for this.](http://guides.rubyonrails.org/getting_started.html)

Navigate to your rails apps folder and in a terminal execute:

`rails new instarails`

(An internet connection is probably required as this step fetches ruby gems)

## Add necessary gems

1. Go to the Gemfile in your projects folder and add the extra gems you want to use to the end of your default list of gems, which ends before the "`group :development, :test do`" line
1. We'll be using [Devise](https://github.com/plataformatec/devise#starting-with-rails) for user authentication so follwing its instructions we will:

    1. Go to the Gemfile and add the following lines:

        ```
        # Use devise for user authentication
        gem 'devise'
        ```
    1. From our project directory, execute the following to update our project
    
        `bundle install`
    1. Then we run the generator, in the terminal execute:

        `rails generate devise:install`

        or

        `rails g devise:install` for short
    1. Running that command reveals there are some manual steps we need to perform:
        1. Add the following line to the end of your development.rb file in config/environments/development.rb:

            `config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`

            There is also a note about adding a similar line to your production.rb file when you deploy, but we won't be going that far in this project.
        1. Add a definition of our root url, we will be making a landing page so add the following line to your config/routes.rb file:

            `root to: 'landing#index'`
        1. Add the following lines to our **app/views/layouts/application.html.erb** file so that flash messages can be displayed to the user:

            ```erb
            <p class="notice"><%= notice %></p>
            <p class="alert"><%= alert %></p>
            ```
        1. There is one final instruction which we won't do to keep this app simple, but that is to execute the following to provide a bunch of devise default views for our app that would be used for when the user wanted to do things such as change their password etc:

            `rails g devise:views`

            Again, we won't be doing that here, but it would give you a **devise** folder within app/views with a bunch of views you could customize related to devise.
    1. Running the generator for devise also installs an initializer at **config/initializers/devise.rb** which is where you need to look in to adjust settings such as how long a users session remains logged in before expiring, number of times a password is to be hashed etc.

    1. Now we are up to the stage of creating the user model, execute the following command:

        `rails g devise User`

        That will create a user.rb model in app/models as well as a migration file in db/migrate and add a devise route for users in config/routes.rb

        on my machine the files had the following contents:

        migrate file:

        ```ruby
        # frozen_string_literal: true

        class DeviseCreateUsers < ActiveRecord::Migration[5.1]
          def change
            create_table :users do |t|
              ## Database authenticatable
              t.string :email,              null: false, default: ""
              t.string :encrypted_password, null: false, default: ""

              ## Recoverable
              t.string   :reset_password_token
              t.datetime :reset_password_sent_at

              ## Rememberable
              t.datetime :remember_created_at

              ## Trackable
              t.integer  :sign_in_count, default: 0, null: false
              t.datetime :current_sign_in_at
              t.datetime :last_sign_in_at
              t.string   :current_sign_in_ip
              t.string   :last_sign_in_ip

              ## Confirmable
              # t.string   :confirmation_token
              # t.datetime :confirmed_at
              # t.datetime :confirmation_sent_at
              # t.string   :unconfirmed_email # Only if using reconfirmable

              ## Lockable
              # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
              # t.string   :unlock_token # Only if unlock strategy is :email or :both
              # t.datetime :locked_at


              t.timestamps null: false
            end

            add_index :users, :email,                unique: true
            add_index :users, :reset_password_token, unique: true
            # add_index :users, :confirmation_token,   unique: true
            # add_index :users, :unlock_token,         unique: true
          end
        end
        ```

        user model file:

        ```ruby
        class User < ApplicationRecord
          # Include default devise modules. Others available are:
          # :confirmable, :lockable, :timeoutable and :omniauthable
          devise :database_authenticatable, :registerable,
                :recoverable, :rememberable, :trackable, :validatable
        end
        ```
    1. After confirming they are there and that we are satisfied with the contents, run the db migrate command:

        `rails db:migrate`
1. We'll also be leveraging Bootstrap so a search for bootstrap gem reveals the [bootstrap-rubygem](https://github.com/twbs/bootstrap-rubygem) github page with the instructions on how to add, following them we will:
    1. Add the following line to our Gemfile:

        ```
        # Use bootstrap for quick styling
        gem 'bootstrap', '~> 4.0.0'
        ```
    1. Ensure that the version of sprockets-rails on our machine is at least version 2.3.2 by executing the following in a terminal:

        `sprockets -v`
        
        (I see 3.7.1 so all good there)
    1. From our project directory, execute the following to update our project
    
        `bundle install`
    1. Change our app/assets/stylesheets/application.css file to have the extension of scss instead and then remove all of its default contents and just add the following line:

        `@import "bootstrap";`
        
        That will be enough to serve us for our purposes now as the remaining instructions are to do with javascript which we won't be using in this project.

## Create a landing page that will have provisions for signing in and signing up

1. We want a controller for our landing page with an index method so run the rails generate controller command:
  
    `rails g controller landing index`
    
1. Then remove everything in the app/views/landing/index.html.erb file and replace it with the following content:

    ```erb
    <div class="container-fluid">
      <div class="row">
        <div class="col">
          <h1>Instarails</h1>
          <img src="<%= asset_url('3q3a0859.jpg') %>" class="img-fluid">
        </div>
        <div class="col">
          <h2>The number two photo social app</h2>
        </div>
      </div>
    </div>
    ```
1. In the above code, the filename 3q3a0859.jpg is an image found online of an iphone x, it was downloaded and put into the app/assets/images folder, you can grab [this copy](app/assets/images/3q3a0859.jpg) if you want to look the same.
1. Now we can run the rails server and see how it's looking, run the rails server with the following command:

    `rails server`

    or the shorthand version:

    `rails s`

    and then you should hopefully see something like this:
    ![image of initial landing page](readme-assets/screenshot-landing-0.jpg)

## Neaten up our views layout with some more bootstrap
1. The above code for index view of landing already contained some bootstrap code. Adding bootstrap to your project is basically adding a library of css rules which we can invoke on our html elements by giving them particular classes.

    We can quickly give some margin to our h1 element by adding the class 'mt-3':

    `<h1 class="mt-3">Instarails</h1>`

    which basically says margin-top: 1rem [as per the docs](https://getbootstrap.com/docs/4.0/utilities/spacing/)

    Add the same utility class to the h2 element:

    `<h2 class="mt-3">The number two photo social app</h2>`

## Make use of devise actions

1. Next we want to add a sign in link to the landing page, to do that we see from the [devise wiki](https://github.com/plataformatec/devise/wiki/How-To:-Add-sign_in,-sign_out,-and-sign_up-links-to-your-layout-template) that there's a section on adding sign in sign out etc links to your layout, the one for signing in is `new_user_session_path`, add the following code to the landing index.html.erb just underneath the h2 element:

    ```erb
    <nav>
        <%= link_to 'Sign in', new_user_session_path %>
    </nav>
    ```

    Note the above is ruby shorthand for `link_to ('Sign in', new_user_session_path)`, we're just calling a function.
1. The link for new user sign up is `new_user_registration_path` so we can add that as well:

    ```erb
    <nav>
        <%= link_to 'Sign in', new_user_session_path %>
        <%= link_to 'Sign up', new_user_registration_path %>
    </nav>
    ```
1. To make the links more relevant depending on the user's signed in status we can simply add an if statement to conditionally show particular links:

    ```erb
    <nav>
        <% if user_signed_in? %>
            <%= link_to 'Edit account', edit_user_registration_path %>
            <%= link_to 'Sign out', destroy_user_session_path, method: :delete %>
        <% else %>
            <%= link_to 'Sign in', new_user_session_path %>
            <%= link_to 'Sign up', new_user_registration_path %>
        <% end %>
    </nav>
    ```
## Use Bootstrap to turn the links into buttons
1. There are some class names we can use on our links to make them look more like buttons: `btn` and then the type of button, eg. `btn-primary`, `btn-light`, `btn-dark`, etc.

    We add them to the end of the `link_to`'s arguments:

    ```erb
    <nav>
        <% if user_signed_in? %>
            <%= link_to 'Edit account', edit_user_registration_path, class: 'btn btn-default'  %>
            <%= link_to 'Sign out', destroy_user_session_path, method: :delete, class: 'btn btn-danger'  %>
        <% else %>
            <%= link_to 'Sign in', new_user_session_path, class: 'btn btn-default' %>
            <%= link_to 'Sign up', new_user_registration_path, class: 'btn btn-default'  %>
        <% end %>
    </nav>
    ```

## Use the Shrine gem for image uploading
1. Following from the [quick start](https://github.com/janko-m/shrine#quick-start) section of the Shrine readme on github we'll add the following line to our gemfile:

    ```
    # use shrine for image uploading
    gem 'shrine'
    ```
1. Then create a file called shrine.rb in the config/initializers folder with the following content (which comes from the quick start guide):

    ```ruby
    require "shrine"
    require "shrine/storage/file_system"

    Shrine.storages = {
    cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
    store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store"), # permanent
    }

    Shrine.plugin :sequel # or :activerecord
    Shrine.plugin :cached_attachment_data # for forms
    Shrine.plugin :rack_file # for non-Rails apps
    ```
1. We want to make a couple of changes to that file to suit our situation (rails) so...
    1. Change the third last line from using sequel to use instead activerecord as that is what rails uses:

        `Shrine.plugin :activerecord # or :sequel`
    1. Comment out the last line as that is for non-rails apps judging by the comment
1. Copy the code from the [examples image_uploader model](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/app/models/image_uploader.rb) and paste into your own image_uploader.rb file stored in app/models.
1. Notice this is file that contains the code that handles resizing images to a certain size. In this case it takes the original image and creates a thumbnail version of it which is 300x300 and then it saves both versions together.
1. Checking the Gemfile example on [Shrine's github](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/Gemfile) there is also some other gems that we'll need so add the following lines to your gemfile:

    ```
    gem 'fastimage' # for store_dimensions plugin
    # Processing
    gem 'image_processing'
    gem 'mini_magick'
    ```
1. run a bundle install to get those gems
1. Then we want to copy the examples [photo model](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/app/models/photo.rb) and in checking the examples migration file for photo model we see that they just made a simple model named Photo with an image_data string attribute.

    But here is where it gets tricky, because looking at the Shrine readme in the quick start section, the code snippets reveal that while they're using the name image for the variable that is the actual uploaded image, in the database they specify it must be named image_data.

    <em>**Edit**: What follows seems a bit hacky because I originally used scaffolding to make the photo resource and specified its image attribute as image_data so that it would be like that in the database (as per the docs) but this necessitates the need for me to then go back through the form and the controller and change it in those places to just be 'image'.</em>

    Because we want all the CRUD (Create, Read, Update, Destroy) functionality we can leverage the rails scaffold command.

    In a terminal in your projects directory execute:

    `rails g scaffold Photo image_data:string user:references description:text`

    followed by:

    `rails db:migrate`
1. If your server is running you might need to restart, and you should see a form for creating a new photo if you visit http://localhost:3000/photos/new
1. The field for the image data is currently just a text box so we want to change that to be a file selector. Go to your `app/views/photos/_form.html.erb` file and change the `form.text_field` for the Image data row to be `form.file_field`
1. Checkout the `photos_controller.rb` file and scroll to the bottom where the params whitelist is and remove the `user_id` because we don't want the user to be able to submit a photo under the guise of another user.
1. Likewise, go to the `_form.html.erb` for photos and remove the row regarding the user id.
1. Then assign the current user to be the user of the uploaded photo by going to the `photos_controller.rb` file and in the create method after @photo is set to a new Photo object set the @photo.user to be the current user:

    `@photo.user = current_user`

1. Now because we scaffolded to create the photo resource and used `image_data` as the name of one of its attributes (because the shrine readme demanded the table in the database have the `_data` appended to the name of the attribute) we have to fix where the scaffold used that name in the controller and the views and revert it back to `image`:

    1. Go to the `app/views/photos/_form.html.erb` file and you could just find all `image_data` and replace with `image`.
    1. Go to the `app/controllers/photos_controller.rb` file and scroll to the bottom where the params whitelist line is and edit that to remove the `_data` from `image_data`.

        `params.require(:photo).permit(:image_data, :description)`

        becomes

        `params.require(:photo).permit(:image, :description)`
    1. Go to the `app/views/photos/index.html.erb` file and rename the part where it has `<%= photo.image_data %>` to `<%= photo.image %>`
    
    Again the reason for doing this is that we want our photo model to have an attribute `image` but the docs for Shrine indicate that in the database the table column must be named with the `_data` added to the end, so `image_data`.

1. Now how to display the image. First go to the `image_uploader.rb` file and check the end of it. You should see a line like this: `{ original: io, small: small }` which indicatese the different versions of the image you'll have available.

    With that information handy we know there is one called 'original' and one called 'small', now go to the show page for photos and find the line that is to display the image which is currently probably just `<%= @photo.image %>`
    we need to decide which version we want to display on the show page and I think I will go with original sized, and then we can do this:

    `<%= image_tag @photo.image[:original].url %>`

1. In the index.html.erb for photos I think would be the appropriate place to use the small version.

    In `app/views/photos/index.html.erb` change the line

    `<td><%= photo.image_data %></td>`

    to

    `<td><%= image_tag photo.image[:small].url %></td>`

    1. If you left it as image_data above, you would get an error screen when you attempted to view the index page for photos in your browser, the rails error screen comes with a terminal where you can query the state of things, if we jump in there and type:
    
    `photo.image`
    
    we'll get what looks like an object, a hash with two keys, :original and :small.

    if we do this:

    `photo.image_data`

    we see that we get the same thing but it's a string representation of the hash, and we can't extract the value for a given key from the string like we can for an actual hash object.

    So when we do 
    
    `photo.image[:original]`

    we get 

    `#<ImageUploader::UploadedFile:0x007f0525e09008 @data={"id"=>"photo/5/image/original-7adcffbb480199b5bc5b34861865ccdb.png", "storage"=>"store", "metadata"=>{"filename"=>"darthbuddha.png", "size"=>112295, "mime_type"=>"image/png", "width"=>362, "height"=>497}}>`

    if we do 

    `photo.image[:original].methods`

    we get:

    ```
    [:width, :height, :dimensions, :==, :eql?, :size, :to_io, :hash, :replace, :delete, :read, :open, :rewind, :eof?, :close, :exists?, :data, :metadata, :extension, :download, :url, :id, :content_type, :original_filename, :to_json, :as_json, :mime_type, :shrine_class, :storage_key, :storage, :uploader, :`, :to_yaml, :to_yaml_properties, :blank?, :present?, :presence, :psych_to_yaml, :acts_like?, :to_param, :to_query, :deep_dup, :duplicable?, :in?, :presence_in, :instance_values, :instance_variable_names, :with_options, :html_safe?, :pretty_print, :pretty_print_cycle, :pretty_print_instance_variables, :pretty_print_inspect, :require_dependency, :unloadable, :require_or_load, :load_dependency, :try, :try!, :instance_of?, :kind_of?, :is_a?, :tap, :public_send, :class_eval, :remove_instance_variable, :instance_variable_set, :method, :public_method, :singleton_method, :extend, :define_singleton_method, :to_enum, :enum_for, :suppress_warnings, :gem, :byebug, :remote_byebug, :debugger, :<=>, :===, :=~, :!~, :respond_to?, :freeze, :inspect, :object_id, :send, :display, :to_s, :pretty_inspect, :nil?, :class, :singleton_class, :clone, :dup, :itself, :taint, :tainted?, :untaint, :untrust, :untrusted?, :trust, :frozen?, :methods, :singleton_methods, :protected_methods, :private_methods, :public_methods, :instance_variable_get, :instance_variables, :instance_variable_defined?, :!, :!=, :__send__, :equal?, :instance_eval, :instance_exec, :__id__]
    ```

    And within that long list of methods for things that could be very useful to us at a later time, we see `:url` which is why we can do:

    `photo.image[:original].url` 

    and then couple that with an `image_tag`

1. In the `show.html.erb` file for photos change the `@photo.user` value to instead be their email, `@photo.user.email`


# Note to self; ensure you cover the following:


* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
