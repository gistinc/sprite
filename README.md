# sprite #

`sprite` is a gem that helps generate css sprite images automagically. It's aim is to support all web frameworks (Merb/Rails/Sinatra), and have extensible output generator. By default, it supports CSS and SASS output (via mixins).

## INSTALL  ##

### Install the `rmagick` gem ###

sprite currently requires the rmagick gem. to install it, use

    gem install rmagick

if you have any problems with the rmagick gem, install imagemagick via macports first:

    sudo port install libxml2
    sudo port install ImageMagick  

or via installer: http://github.com/maddox/magick-installer/tree/master

### Install the `sprite` gem ###

Install the sprite gem from gemcutter

    gem sources -a http://gemcutter.org
    gem install sprite

### if using Merb ###

With Merb 1.1 and Bundler, just add the line `gem 'sprite'` your ./Gemfile and then run `gem bundle`

### if using Rails ###

add to environment.rb
    
    config.gem "sprite"

or install as a plugin

    script/plugin install git://github.com/merbjedi/sprite.git

## USAGE ##

if installed as a gem, at your root project folder you can just run 
  
    sprite

if you would rather not install the gem, you can also use it with rake

    rake sprite:build


### Intelligent Defaults ###

Without having to configure anything, `sprite` will allow you to easily generate sprites based on a couple default folder settings we give you right off the bat.

For example, given you have the following setup:
  
    public/
      images/
        sprites/
          black_icons/
            stop.png
            go.png
            back.png
            forward.png
        
          weather/
            sunny.gif
            rainy.gif
            cloudy.gif
  
Running `sprite` with no configuration file will generate the following files:
  
    public/
      stylesheets/
        sprites.css
      images/
        sprites/
          black_icons.png
          weather.png

Any folders within `public/images/sprites/` will get compressed into a merged image file at the same location. Then `sprites.css` got generated in the stylesheets folder with all the class definitions for these files. Just include `sprites.css` into your stylesheet and you're ready to go!


## CONFIGURATION ##

Configuration of `sprite` is done via `config/sprite.yml`. It allows you to set sprite configuration options, and fine tune exactly which sprites get generated where.
  
* `config:` section defines all the global properties for sprite generation. Such as how it generates the styles, where it looks for images, where it writes it output file to, and what image file format it uses by default
  - `style:` defines how the style rules are outputted. built in options are `css`, `sass`, and `sass_mixin`. (defaults to `css`)
  - `output_path:` defines the file path where your style settings get written. the file extension not needed as it will be determined by the style setting above (defaults to `public/stylesheets/sprite`)
  - `image_output_path:` defines the folder path where the combined sprite images files are written (defaults to `public/images/sprite/`)
  - `source_path:` defines the folder where source image files are read from (defaults to `public/images/`)
  - `default_format:` defines the default file image format of the generated files. (defaults to `png`)
  - `class_separator:` used within the generated class names between the image name and sprite name (defaults to `_`)

* `images:` section provides an array of configurations which define which image files are built, and where they get their sprites from. each image setup provides the following config options:
  - `name:` name of image (required)
  - `sources:` defines a list of source image filenames to build the target image from (required). They are parsed by <code>Dir.glob</code>
  - `align:` defines the composite gravity type, horizontal or vertical. (defaults to `vertical`)
  - `spaced_by:` spacing (in pixels) between the combined images. (defaults to `0`)
  - `format:` define what image file format gets created (optional, uses `default_format` setting if not set)

you can define any number of destination image files.

### Sample Configuration `config/sprite.yml` ###

    # defines the base configuration options (file paths, etc, default style, etc)

    config:
      style: css
      output_path: public/sass/mixins/sprites.sass
      image_output_path: public/images/sprites/
      source_path: public/images/
      class_separator: '_'
      default_format: png
    
    # defines what sprite collections get created
    images:    

      # creates a public/images/sprites/blue_stars.png image with 4 sprites in it
      - name: blue_stars
        format: png
        align: horizontal
        spaced_by: 50
        sources:
          - icons/blue_stars/small.png
          - icons/blue_stars/medium.png
          - icons/blue_stars/large.png
          - icons/blue_stars/xlarge.png
      
      # creates a public/images/sprites/green_stars.jpg image with 
      # all the jpg files contained within /images/icons/green_stars/
      - name: green_stars
        format: jpg
        align: vertical
        spaced_by: 50
        sources:
          - icons/green_stars/*.jpg

### Style Settings ###

By default, it will use with `style: css` and generate the file at `public/stylesheets/sprites.css`

    .sprites.blue_stars_small {
      background: url('/images/icons/blue_stars/small.png') no-repeat 0px 0px;
      width: 12px;
      height: 6px;
    }
    .sprites.blue_stars_medium {
      background: url('/images/icons/blue_stars/medium.png') no-repeat 0px 6px;
      width: 30px;
      height: 15px;
    }
    .sprites.blue_stars_large {
      background: url('/images/icons/blue_stars/large.png') no-repeat 0px 21px;
      width: 60px;
      height: 30px;
    }
    .sprites.blue_stars_xlarge {
      background: url('/images/icons/blue_stars/xlarge.png') no-repeat 0px 96px;
      width: 100px;
      height: 75px;
    }

We also support mixin syntax via `style: sass_mixin`. If set, sprite will only generate a yml with your specific sprite configurations. It then provides a SASS mixin which you can use in order to mix in these sprites anywhere within your SASS stylesheets.

    // you can then use your sprite like this
    .largebluestar
      +sprite("blue_stars", "large")

    .mysmallbluestar
      +sprite("blue_stars", "small")

## ABOUT `sprite` ##

`sprite` was originally based off of Richard Huang's excellent Rails specific [`css_sprite`](http://github.com/flyerhzm/css_sprite) plugin

Since then it's been rebuilt (with some reuse of the image generation code) to be a general purpose ruby executable, with hooks for merb/rails/sinatra


## LICENSE  ##

Released under the MIT License

## COPYRIGHT ##

Copyright (c) 2009 [Jacques Crocker (merbjedi@gmail.com)]

Original Codebase Copyright (c) 2009 [Richard Huang (flyerhzm@gmail.com)]
