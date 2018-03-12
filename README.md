# Instarails from scratch - a VERY simple instagram clone
Created with Rails 5.1.4

This is a walkthrough of a class exercise to create an Instagram like site 
using rails.
## Create a new rails project

Ensure you have the appropriate prerequisites sorted for your development 
machine.
[The rails guide is a good resource for this.](http://guides.rubyonrails.org/getting_started.html)

Navigate to your rails apps folder and in a terminal execute:

`rails new instarails`

(An internet connection is probably required as this step fetches ruby gems)

## Add necessary gems

1. Go to the Gemfile in your projects folder and add the extra gems you want 
to use to the end of your default list of gems, which ends before the "`group 
:development, :test do`" line
1. We'll be using 
[Devise](https://github.com/plataformatec/devise#starting-with-rails) for user 
authentication so follwing its instructions we will:

    1. Go to the Gemfile and add the following lines:

        ```
        # Use devise for user authentication
        gem 'devise'
        ```
    1. From our project directory, execute the following to update our project
    
        `bundle install`

        followed by a restart of your rails server if it is running.
    1. Then we run the generator, in the terminal execute:

        `rails generate devise:install`

        or

        `rails g devise:install` for short
    1. Running that command reveals there are some manual steps we need to 
    perform:
        1. Add the following line to the end of your development.rb file in config/environments/development.rb:

            `config.action_mailer.default_url_options = { host: 'localhost',
            port: 3000 }`

            There is also a note about adding a similar line to your 
            production.rb file when you deploy, but we won't be going that far 
            in this project.
        1. Add a definition of our root url, we will be making a landing page 
        so add the following line to your config/routes.rb file:

            `root to: 'landing#index'`
        1. Add the following lines to our 
        **app/views/layouts/application.html.erb** file so that flash messages 
        can be displayed to the user:

            ```erb
            <p class="notice"><%= notice %></p>
            <p class="alert"><%= alert %></p>
            ```
        1. There is one final instruction which we won't do to keep this app 
        simple, but that is to execute the following to provide a bunch of 
        devise default views for our app that would be used for when the user 
        wanted to do things such as change their password etc:

            `rails g devise:views`

            Again, we won't be doing that here, but it would give you a 
            **devise** folder within app/views with a bunch of views you 
            could customize related to devise.
    1. Running the generator for devise also installs an initializer at **config/initializers/devise.rb** which is where you need to look in to
    adjust settings such as how long a users session remains logged in before 
    expiring, number of times a password is to be hashed etc.

    1. Now we are up to the stage of creating the user model, execute the 
    following command:

        `rails g devise User`

        That will create a user.rb model in app/models as well as a migration 
        file in db/migrate and add a devise route for users in config/routes.rb

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
    1. After confirming they are there and that we are satisfied with the 
    contents, run the db migrate command:

        `rails db:migrate`
1. We'll also be leveraging Bootstrap so a search for bootstrap gem reveals 
the [bootstrap-rubygem](https://github.com/twbs/bootstrap-rubygem) github page 
with the instructions on how to add, following them we will:
    1. Add the following line to our Gemfile:

        ```
        # Use bootstrap for quick styling
        gem 'bootstrap', '~> 4.0.0'
        ```
    1. Ensure that the version of sprockets-rails on our machine is at least 
    version 2.3.2 by executing the following in a terminal:

        `sprockets -v`
        
        (I see 3.7.1 so all good there)
    1. From our project directory, execute the following to update our project
    
        `bundle install`

        followed by a restart of your rails server if it is running.
    1. Change our app/assets/stylesheets/application.css file to have the 
    extension of scss instead and then remove all of its default contents and 
    just add the following line:

        `@import "bootstrap";`
        
        That will be enough to serve us for our purposes now as the remaining 
        instructions are to do with javascript which we won't be using in this project.

## Create a landing page that will have provisions for signing in and signing up

1. We want a controller for our landing page with an index method so run the 
rails generate controller command:
  
    `rails g controller landing index`
    
1. Then remove everything in the app/views/landing/index.html.erb file and 
replace it with the following content:

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
1. In the above code, the filename 3q3a0859.jpg is an image found online of 
an iphone x, it was downloaded and put into the app/assets/images folder, 
you can grab [this copy](app/assets/images/3q3a0859.jpg) if you want to look 
the same.
1. Now we can run the rails server and see how it's looking, run the rails 
server with the following command:

    `rails server`

    or the shorthand version:

    `rails s`

    and then you should hopefully see something like this:
    ![image of initial landing page](readme-assets/screenshot-landing-0.jpg)

## Neaten up our views layout with some more bootstrap
1. The above code for index view of landing already contained some bootstrap 
code. Adding bootstrap to your project is basically adding a library of css 
rules which we can invoke on our html elements by giving them particular 
classes.

    We can quickly give some margin to our h1 element by adding the class 
    'mt-3':

    `<h1 class="mt-3">Instarails</h1>`

    which basically says margin-top: 1rem [as per the docs](https://getbootstrap.com/docs/4.0/utilities/spacing/)

    Add the same utility class to the h2 element:

    `<h2 class="mt-3">The number two photo social app</h2>`

## Make use of devise actions

1. Next we want to add a sign in link to the landing page, to do that we see 
from the [devise wiki](https://github.com/plataformatec/devise/wiki/How-To:-Add-sign_in,-sign_out,-and-sign_up-links-to-your-layout-template) 
that there's a section on adding sign in sign out etc links to your layout, 
the one for signing in is `new_user_session_path`, add the following code to
the landing index.html.erb just underneath the h2 element:

    ```erb
    <nav>
        <%= link_to 'Sign in', new_user_session_path %>
    </nav>
    ```

    Note the above is ruby shorthand for `link_to ('Sign in',
    new_user_session_path)`, we're just calling a function.
1. The link for new user sign up is `new_user_registration_path` so we can add 
that as well:

    ```erb
    <nav>
        <%= link_to 'Sign in', new_user_session_path %>
        <%= link_to 'Sign up', new_user_registration_path %>
    </nav>
    ```
1. To make the links more relevant depending on the user's signed in status we
can simply add an if statement to conditionally show particular links:

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
1. There are some class names we can use on our links to make them look more 
like buttons: `btn` and then the type of button, eg. `btn-primary`, 
`btn-light`, `btn-dark`, etc.

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
1. Following from the [quick start](https://github.com/janko-m/shrine#quick-start) 
section of the Shrine readme on github we'll add the following line to our 
gemfile:

    ```
    # use shrine for image uploading
    gem 'shrine'
    ```
1. Then create a file called shrine.rb in the config/initializers folder with 
the following content (which comes from the quick start guide):

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
1. We want to make a couple of changes to that file to suit our situation 
(rails) so...
    1. Change the third last line from using sequel to use instead activerecord
    as that is what rails uses:

        `Shrine.plugin :activerecord # or :sequel`
    1. Comment out the last line as that is for non-rails apps judging by the 
    comment
1. Copy the code from the [examples image_uploader model](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/app/models/image_uploader.rb) 
and paste into your own image_uploader.rb file stored in a new folder you'll 
create within the app folder called 'uploaders', here's the code:

    ```ruby
    require "image_processing/mini_magick"

    class ImageUploader < Shrine
        include ImageProcessing::MiniMagick

        ALLOWED_TYPES = %w[image/jpeg image/png]
        MAX_SIZE      = 10*1024*1024 # 10 MB

        plugin :remove_attachment
        plugin :pretty_location
        plugin :processing
        plugin :versions
        plugin :validation_helpers
        plugin :store_dimensions

        Attacher.validate do
            validate_max_size MAX_SIZE
            if validate_mime_type_inclusion(ALLOWED_TYPES)
                validate_max_width 5000
                validate_max_height 5000
            end
        end

        process(:store) do |io, context|
            small = resize_to_limit!(io.download, 300, 300) { |cmd| cmd.auto_orient }

            { original: io, small: small }
        end
    end
    ```
1. Notice this is the file that contains the code that handles resizing images 
to a certain size. In this case it takes the original image and creates a 
small (thumbnail) version of it which is 300x300 and then it saves both 
versions together.
1. Checking the Gemfile example on [Shrine's github](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/Gemfile) 
there is also some other gems that we'll need so add the following lines to 
your gemfile:

    ```
    gem 'fastimage' # for store_dimensions plugin
    # Processing
    gem 'image_processing'
    gem 'mini_magick'
    ```
1. Run a bundle install to get those gems followed by a restart of your rails 
server if it is running.
1. Then we want to reproduce the examples [photo model](https://github.com/erikdahlstrand/shrine-rails-example/blob/master/app/models/photo.rb)
and in checking the examples migration file for photo model we see that they 
just made a simple model named Photo with an image_data string attribute.

    But here is where it gets tricky, because looking at the Shrine readme in 
    the quick start section, the code snippets reveal that while they're using 
    the name `image` for the variable that is the actual uploaded image, in 
    the database they specify it must be named `image_data`.

    <em>**Edit**: What follows seems a bit hacky because I originally used 
    scaffolding to make the photo resource and specified its image attribute as
    `image_data` so that it would be like that in the database (as per the docs)
    but this necessitates the need for me to then go back through the form and
    the controller and change it in those places to just be `image`.</em>

    Because we want all the CRUD (Create, Read, Update, Destroy) functionality 
    we can leverage the rails scaffold command.

    In a terminal in your projects directory execute:

    `rails g scaffold Photo image_data:string user:references description:text`

    Then we need to run a migration to establish the database columns for our 
    photo model.

    `rails db:migrate`

    Then go to your photo model file, `app/models/photo.rb`, and add the 
    following line just after the `class` line as per the shrine readme:

    `include ImageUploader::Attachment.new(:image) # adds an 'image' virtual
    attribute`

1. If your server is running you may need to restart, and you should see a form
for creating a new photo if you visit http://localhost:3000/photos/new
1. The field for the image data is currently just a text box so we want to 
change that to be a file selector. Go to your `app/views/photos/_form.html.erb`
file and change the `form.text_field` for the Image data row to be
`form.file_field`
1. Checkout the `photos_controller.rb` file and scroll to the bottom where the 
params whitelist is and remove the `user_id` because we don't want the user to 
be able to submit a photo under the guise of another user.
1. Likewise, go to the `_form.html.erb` for photos and remove the row regarding
the user id.
1. Then assign the current user to be the user of the uploaded photo by going 
to the `photos_controller.rb` file and in the create method after @photo is set
to a new Photo object set the @photo.user to be the current user:

    `@photo.user = current_user`

1. Now because we scaffolded to create the photo resource and used `image_data`
as the name of one of its attributes (because the shrine readme demanded the 
table in the database have the `_data` appended to the name of the attribute) 
we have to fix where the scaffold used that name in the controller and the views
and revert it back to `image` because while shrine expects the database column 
to have the `_data` appended to the name of the models attribute it doesn't want
that to be part of the name of the attribute used elsewhere throughout the 
program:

    1. Go to the `app/views/photos/_form.html.erb` file and you could just find 
    all `image_data` and replace with `image`.
    1. Go to the `app/controllers/photos_controller.rb` file and scroll to the 
    bottom where the params whitelist line is and edit that to remove the 
    `_data` from `image_data`.

        `params.require(:photo).permit(:image_data, :description)`

        becomes

        `params.require(:photo).permit(:image, :description)`
    1. Go to the `app/views/photos/index.html.erb` file and rename the part 
    where it has `<%= photo.image_data %>` to `<%= photo.image %>`
    1. At this point you should now have `image` and **not** `image_data` 
    appearing in the following files:
        * `app/views/photos/_form.html.erb`
        * `app/views/photos/show.html.erb`
        * `app/views/photos/index.html.erb`
        * `app/uploaders/image_uploader.rb`
        * `app/controllers/photos_controller.rb`
    1. And you should only have `image_data` appearing in your database which 
    you can confirm by checking the following files:
        * `db/schema.rb`
        * `db/migrate/` and then check the migration that introduced the Photo 
        model
        * Alternatively, in your projects directory in a terminal type `rails 
        console` then in there type `Photo.inspect` and ensure that one of it's 
        attributes is called `image_data` and not just `image`.
    Again the reason for doing this is that we want our photo model to have an 
    attribute `image` but the docs for Shrine indicate that in the database the 
    table column must be named with the `_data` added to the end, so 
    `image_data`.

1. Now how to display the image. First go to the `image_uploader.rb` file and 
check the end of it. You should see a line like this: `{ original: io, small: 
small }` which indicatese the different versions of the image you'll have 
available.

    With that information handy we know there is one called 'original' and one 
    called 'small', now go to the show page for photos and find the line that 
    is to display the image which is currently probably just 
    `<%= @photo.image %>`
    we need to decide which version we want to display on the show page and I 
    think I will go with original sized, and then we can do this:

    `<%= image_tag @photo.image[:original].url %>`

1. In the index.html.erb for photos I think would be the appropriate place to 
use the small version.

    In `app/views/photos/index.html.erb` change the line

    `<td><%= photo.image_data %></td>`

    to

    `<td><%= image_tag photo.image[:small].url %></td>`

    1. If you left it as image_data above, you would get an error screen when 
    you attempted to view the index page for photos in your browser, the rails 
    error screen comes with a terminal where you can query the state of things, 
    if we jump in there and type:
        
        `photo.image`
        
        we'll get what looks like an object, a hash with two keys, :original 
        and :small.

        if we do this:

        `photo.image_data`

        we see that we get the same thing but it's a string representation of 
        the hash, and we can't extract the value for a given key from the 
        string like we can for an actual hash object.

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

        And within that long list of methods for things that could be very 
        useful to us at a later time, we see `:url` which is why we can do:

        `photo.image[:original].url` 

        and then couple that with rails' `image_tag` helper so that we end up 
        with the url being wrapped in the appropriate html in order to render 
        the actual image on in the browser.

1. Note: In the class it was shown that if you're having issues with the 
prerequisites of having imagemagick and graphicsmagick installed, you can work 
around that by removing all the content in `image_uploader.rb` except for the 
class name declaration and in this way you will lose the ability to have your
 uploaded images automatically resized, but it removes a variable if you're 
 struggling to get this to work. If you want to go that route set your 
 `image_uploader.rb` to the following:
    ```ruby
    class ImageUploader < Shrine 
    end
    ```
1. In the `show.html.erb` file for photos change the `@photo.user` value to 
instead be their email, `@photo.user.email`
1. While you're in the show page, if you've done some experimenting already 
with the uploading of images, you may notice that the display of the image on 
the show page (as it's displaying the original size) may not fit the image all 
in the browser especially if you upload a high resolution image or you resize 
the browser to make it smaller. Since we've got Bootstrap at our disposal, 
there is a handy bootstrap class we can use called 'img-fluid', so add that to 
the end of the image_tag line:
    ```ruby
    <%= image_tag @photo.image[:original].url, class: 'img-fluid' %>
    ```

    That will result in the image elegantly resizing itself to fit into the 
    viewport.
## Improve photos page layout
1. The way our /photos page looks at the moment is like any stock rails app so 
it would be better if it was customised a little. 

    In the below source code you can see that the code in the 
    `app/views/photos/index.html.erb` file has been amended to 
    
    * remove the big h1 'photos' header, 
    * make the actual image a link to the image's show page where it can be 
    viewed in full resolution, 
    * moved the user email and the description to be below each image, and
    * added some logic around showing the edit and delete links such that they
    will only show for the user if the photo is one that the user uploaded.

    ```erb
    <p id="notice"><%= notice %></p>

    <section>
        <% @photos.each do |photo| %>
        <article>
            <%= link_to photo do %>
            <figure>
                <%= image_tag photo.image[:small].url alt: photo.description %>
            </figure>
            <% end %>
            <p>
            <strong><%= photo.user.email %></strong> 
            <%= photo.description %>
            </p>
            <% if photo.user == current_user %>
            <%= link_to 'Edit', edit_photo_path(photo) %>
            <%= link_to 'Destroy', photo, method: :delete, data: { confirm: 'Are you sure?' } %>
            <% end %>
        </article>
        <% end %>
    </section>

    <br>

    <%= link_to 'New Photo', new_photo_path %>
    ```
1. Navigate to the `show.html.erb` for the photos and repeat the same trick to 
only show the link to edit if the photos user is the same as the current user.

## Add new photo button to top of page

It would be more convenient if the New Photo link that appears at the end of 
the list of photos were more button-looking and stayed at the top of the page 
as we scrolled down. We can achieve that easily with bootstrap by putting the 
link in a `<nav>` at the top and using bootstrap classes, in particular `btn` 
and `sticky-top`, to achieve this:

```erb
<nav class="nav sticky-top justify-content-center pt-2 pb-2 bg-light">
    <%= link_to 'New Photo', new_photo_path, class: 'btn btn-primary' %>
</nav>
```
## Likes functionality

Next we'll implement the 'likes' functionality, this is the functionality 
where one user can 'like' the photo of another user.
1. Firstly as this is a distinct new feature, lets practice using git branches 
to keep our work separate from our master branch before we're happy with it, 
we'll create and switch to a new branch called 'likes'

    `git checkout -b likes`

1. Liking of photos will be handled with a relationship in our database. We 
can achieve this by using a 
['join table'](https://en.wikipedia.org/wiki/Join_%28SQL%29). Basically this 
will be a table in our database that contains the relations between users and 
photos. 

    A simplified example of our 'user' table might look like this: 
    
    id | email | hashed password
    -----|----|---
    1 | billy@gmail.com | efcd4d9ca350c9dd077e05ea
    2 | barbara@hotmail.com | a13e2e42a9045c842df69531
    3 | ernie@yahoo.com |  7e07f4c8c9b68f384764998a

    And our 'photo' table like this: 
    
    id | user | image_data | description
    -----|----|---|---
    1 | 1 | cXDxh5TAsYhiEXcUw+6zVMov4cs&hellip; | "walk in the park"
    2 | 1 | WYW7NhKKqaTwX2cWR4CWbDAzuZ8&hellip; | "my dog ellie"
    3 | 2 | f0XzSg05KsN+yKLxuQAtIzzF0Uk&hellip; | "new bicycle"

    So the table we need to be able to associate a 'like' between a user and a 
    photo just needs to be like this:

    'likes' table:

    user_id | photo_id
    -----|----
    1 | 3
    3 | 1
    3 | 2

    What the above example would mean then is that user 1 (billy) likes photo 
    3 (barbaras photo of her 'new bicycle') and that is all the photos billy 
    likes.
    
    User 3 (Ernie) then likes two photos, photo 1 ('walk in the park') and 
    photo 2 ('my dog ellie')

    And user 2 (Barbara) hasn't liked any photos yet as evidenced by the lack 
    of any rows in that table that have 2 in the user_id column. 
1. To make the join table execute the following in the terminal:

    `rails g migration CreateJoinTableLikes user photo`

    (for the documentation on this go to 
    http://edgeguides.rubyonrails.org/active_record_migrations.html and search 
    for join table in the 'creating a migration' section.)

1. That will create a migration file that we'll then need to edit so go and 
open it and have a look.
1. If you have dash or zeal installed with the rails documentation you can 
search `create_join_table` as you see it in that migration file for some 
information.
1. Going with the simple name of 'likes' for our table amend the 
create_join_table line from this:

    `create_join_table :users, :photos do |t|`

    to this:

    `create_join_table :users, :photos, table_name: :likes do |t|`
1. Now within that block you'll see that there are two suggestions commented 
out. They are to add an index on particular columns, one adds it to the user 
and one adds it to the photo. The one were user comes before photo means that 
the database will be able to efficiently retrieve all the rows that have a 
particular user id, so that would allow for you to, given a particular user, 
see all the photos that were liked by that user. The reverse, where the photo 
comes before the user, would be to index the photo, so it would be very 
efficient at retrieving all rows that have a particular photo id. This would 
be useful for, given a particular photo, you wanted to find all the users that 
liked that photo.

    I think we would want both in our case, so that if we create a show page 
    for users, when viewing a user we can see all the photos that were liked 
    by that user, but also when we view a photo, we want to be able to see all 
    the users that liked that photo.

    So basically you can go ahead and  uncomment both lines.

1. Next we want to ensure that a particular user can only like a particular 
photo once, so we can apply the unique: true argument to the t.index lines so 
it should now look like this:

    ```ruby
    t.index [:user_id, :photo_id], unique: true
    t.index [:photo_id, :user_id], unique: true
    ```
1. We also want it to save the created at timestamp for every like, so that 
when listing all the users who have liked a photo they can appear in order 
based on when they liked it.

    to do that just add this line in that block:

    `t.timestamp :created_at`

    **Note**: in the above line there is an alternative line you might see 
    floating around in rails documentation called `t.timestamps`, that is 
    basically shorthand for doing both created_at and updated_at, but since in 
    our case we only want/need the one, created_at, we use the singular 
    `t.timestamp` instead. It would be wrong to say `t.timestamps :created_at`
1. Now we're ready to migrate
    `rails db:migrate`
1. To establish our models to help with the 'likes' we'll declare the the user 
model has many photos, and the photo model has and belongs to many likers:

    user.rb:

    ```ruby
    class User < ApplicationRecord
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable and :omniauthable
        devise :database_authenticatable, :registerable,
                :recoverable, :rememberable, :trackable, :validatable

        has_many :photos
    end
    ```
    
    That will allow us to be able to retrieve all the photos that belong to a 
    particular user, not by going `Photo.where(user: id_of_the_user_we_want)` 
    but simply `our_user.photos`

    Similarly for the photo model, we can add the `has_and_belongs_to_many` 
    line as you see below:
    
    photo.rb:

    ```ruby
    class Photo < ApplicationRecord
        include ImageUploader::Attachment.new(:image) # adds an `image` virtual attribute
        belongs_to :user
        has_and_belongs_to_many :likers, class_name: 'User', join_table: :likes
    end
    ```

    Note that we've put in `class_name: 'User'`, that's because without that 
    rails would assume there is a 'liker' model.
    Similarly with the option `join_table: :likes`, we specifically named the 
    join table 'likes' so we have to specify it here otherwise rails would 
    assume there is some join table with both photo and user in the name 
    probably.

    And that will then give us the ability to get all the users who liked a 
    particular photo like this: `our_photo.likers`

    We can also record other users as liking that photo like this: 
    `our_photo.likers << another_user`

    If they then unlike the photo we can just do this: 
    `our_photo.likers.destroy(another_user)`

1. Add some methods to the Photo model that check if a user likes a photo or 
takes a user and adds them to the list of users that like that photo, etc:

    ```ruby
    def liked_by?(user)
        likers.exists?(user.id)
    end

    def toggle_liked_by(user)
        if liked_by?(user)
            likers.destroy(user.id)
        else
            likers << user
        end
    end
    ```
1. Add a 'like' button to the photo show page:

    ```ruby
    <%= form_with(model: @photo, method: :patch) do |form| %>
        <% liked = @photo.liked_by?(current_user) %>
        <%= form.hidden_field :liked, value: liked %>
        <%= form.button liked ? 'Unlike' : 'Like' %>
    <% end %>
    ```

    This way is using a form to allow for the submitting of information back 
    to our server, it's a patch method because we're updating an existing 
    property of the photo model, not making a brand new model or anything, and 
    then it establishes a hidden field in the form preset to a boolean based 
    on whether the user currently likes the photo or not. This is what gets 
    submitted when they click the like or unlike button.

1. Add the like/unlike logic to the controller:

    Because the way we're telling the server that the user likes the photo is 
    with the use of a form and the patch method, it will be routed to the same 
    method in the controller as would the request coming from the form to edit 
    a photo, so we need to add the logic to check if the request coming 
    through is coming from the liking form.

    Add the following method in amongst the other private methods of the 
    photos_controller file:

    ```ruby
    def is_liking?
        # is there a 'liked' field in the form?
        params.require(:photo)[:liked].present?
    end
    ```

    And then change the PATCH/PUT method from this:

    ```ruby

    # PATCH/PUT /photos/1
    # PATCH/PUT /photos/1.json
    def update
        respond_to do |format|
            if @photo.update(photo_params)
                format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
                format.json { render :show, status: :ok, location: @photo }
            else
                format.html { render :edit }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end
    ```

    to:

    ```ruby
    # PATCH/PUT /photos/1
    # PATCH/PUT /photos/1.json
    def update
        respond_to do |format|
            if is_liking?
                #toggle whether this photo is liked by the current user
                @photo.toggle_liked_by(current_user)
                format.html { redirect_to @photo }
                format.json { render :show, status: :ok, location: @photo }
            elsif @photo.update(photo_params)
                format.html { redirect_to @photo, notice: 'Photo was successfully updated.' }
                format.json { render :show, status: :ok, location: @photo }
            else
                format.html { render :edit }
                format.json { render json: @photo.errors, status: :unprocessable_entity }
            end
        end
    end
    ```
# Comments functionality

1. Next is to create the comment model and functionality to allow for comments 
to be made against a photo.

    We want the views for this, to be able to edit and delete comments etc, 
    and so we can just use the scaffold command.

    Our comment model will need:
    * reference to a photo
    * user that made the comment
    * the content of the comment:

    and if you wanted it to be able to support replies to comments, then you 
    can add another attribute that would be a reference back to the comment 
    being replied to:

    * replied to comment of the comment

    Which results in the following scaffold command:

    `rails g scaffold Comment photo:references user:references content:text 
    parent_comment:references`

1. Next because rails won't understand that parent_comment is another comment, 
we should explicitly mention this in the `comment.rb` model file:

    Change the belongs_to line to this:

    ` belongs_to :parent_comment, class_name: 'Comment'`
1. If we look at the migration file that was created by that scaffold command, 
we can see the opportunity to add an index on the created_at time, so just 
below t.timestamps write this:

    `t.index :created_at # allow us to sort chronologically`

    *note: this index is solely on the comment and doesn't take into account 
    the fact that comments will always be tied to a particular photo, so there 
    is probably scope here for making this index more fine tuned than how it 
    currently is, which is over ALL comments.*

1. Next migrate: `rails db:migrate`
1. Now if we check our routes, we'll see that we have a line resources :comments
    
    If you're seeing it at the top of the other lines, you might have the 
    opportunity to do some reordering, for convention and logic's sake, the 
    below is a good example:

    ```ruby
    Rails.application.routes.draw do
    root to: 'landing#index'
    devise_for :users
    resources :photos
    resources :comments
    ```
1. Now because the above will result in paths like /photos and /comments, but 
we don't want to be able to see comments unless we're looking at a particular 
photo, and even then we only want to be seeing the comments that apply to that 
photo, what we can do is describe to rails that our comments are nested within 
our photos, and to do that we simply wrap the `resources :comments` line in a 
do end block like so:

    ```ruby
    Rails.application.routes.draw do
    root to: 'landing#index'
    devise_for :users
    resources :photos do
        resources :comments
    end
    ```

1. By doing that our routes will change from basically `/comments` to 
`/photos/#id/comments`, and as a result we'll now need to adjust the 
places where scaffolded links were assuming that comments was a top level 
path. So for example we need to change the following line in our comments 
index.html.erb file:

    ```ruby
    <%= link_to 'New Comment', new_comment_path %>
    ```

    to

    ```ruby
    <%= link_to 'New Comment', new_photo_comment_path %>
    ```

    We can confirm this path by checking the output of running the command 
    `rails routes` and seeing the entry with prefix `new_photo_comment`, that
    means there will be available the methods `new_photo_comment_path` and 
    `new_photo_comment_url`.
    
    And then we also have to provide which photo it's tied to:

    ```ruby
    <%= link_to 'New Comment', new_photo_comment_path(@photo) %>
    ```
1. Now we need to establish which photo @photo is going to be set to, and to do 
that we'll have to go to the comments controller and add the following lines in 
the private methods:

    ```ruby
    def set_photo
      @photo = Photo.find(params[:photo_id])
    end
    ```

    How did we know that we would have the param photo_id provided for us if we 
    didn't know the convention?

    We can check the routes! `rails routes` produces output and in the URI 
    pattern for new comment we can see 
    `/photos/:photo_id/comments/new(.:format)` so that tells us that the param
    for the photo is called photo_id.

    Additionally if we visited our site at this path (assuming you are signed 
    in and have at least one photo uploaded) 
    `http://localhost:3000/photos/1/comments` then we can see an error page as 
    a result of trying to refer to @photo without it being defined, 

    ![photo_id parameter shown in error message](/readme-assets/comments-path-photo-id.png)

    Then be sure to set the photo before any of the other actions:

    ```ruby
    before_action :set_photo
    ```
    
1. Now if you navigate to a photo and tack on `/comments` to the end of that 
path you should see a comments page with a link to create a new comment.

    eg: `http://localhost:3000/photos/1/comments`


1. At this stage if you try to click on the 'new comment' link you will get 
a rails error screen with the message: `undefined method 'comments_path'`.
This is another path that we'll need to adjust as a result of us nesting the 
comments within the photos in the routes.

    In the new.html.erb page for comments, change the line: 

    `<%= link_to 'Back', comments_path %>`

    to

    `<%= link_to 'Back', photo_comments_path(@photo) %>`

    And because the new page will also render the comment form partial, we'll
    need to modify that as well. So in the _form.html.erb file for Comments 
    change the top line from :

    `<%= form_with(model: comment, local: true) do |form| %>`

    to 

    `<%= form_with(model: [@photo, comment], local: true) do |form| %>`

    Which we can do because that is how you can refer to objects with URLs in 
    rails as documented in the [rails guides](http://guides.rubyonrails.org/routing.html#creating-paths-and-urls-from-objects)

## Integrate the new comments form into the Photo page

1. It would be nicer if the user didn't have to navigate to a completely 
different page just to leave a comment on a photo, so what we want to do is get
the new comment form to render on the photo show page.

1. In the comments index.html.erb file replace the code at the bottom of the 
table with the following:

    ```ruby
    <%= render 'form', comment: @new_comment %>
    ```

1. Set up the provisions for that new @new_comment variable in the comments 
controller by removing the new method and moving it's logic into the index 
method and renaming the variable:

    ```ruby
    def index
        @comments = Comment.all
        @new_comment = Comment.new
    end
    ```

1. Delete the file app/views/comments/new.html.erb since we won't be needing 
that.

1. 


#### Note to self; ensure you cover the following:


* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
