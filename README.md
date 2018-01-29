# Instarails from scratch - a VERY simple instagram clone
Created with Rails 5.1.4
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
    1. Running the generator for devise also installs an initializer at config/initializers/devise.rb which is where you need to look in to adjust settings such as how long a users session remains logged in before expiring, number of times a password is to be hashed etc.

    1. 

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






# Note to self; ensure you cover the following:


* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
