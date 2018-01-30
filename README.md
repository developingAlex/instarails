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
1. 
# Note to self; ensure you cover the following:


* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
