# sprite #

`sprite` is a gem that helps generate css sprite images automagically. It's aim is to support all web frameworks (Merb/Rails/Sinatra), and have extensible output generator. By default, it supports CSS and SASS output (via mixins).

## INSTALL  ##

### Install the `rmagick` gem ###

`sprite` currently requires the rmagick gem. to install it, use

    gem install rmagick

if you have any problems with the rmagick gem, install imagemagick via macports first:

    sudo port install libxml2
    sudo port install ImageMagick  

or via installer: http://github.com/maddox/magick-installer/tree/master

### Install the `sprite` gem ###

Install the `sprite` gem from gemcutter

    gem sources -a http://gemcutter.org
    gem install sprite

## USAGE ##

if installed as a gem, at your root project folder you can just run 
  
    sprite

### Intelligent Defaults ###

Without having to configure anything, `sprite` will allow you to easily generate sprites based on a couple default folder settings we give you right off the bat.

For example, given you have the following setup:
  
    public/
      images/
        sprites/
          black-icons/
            stop.png
            go.png
            back.png
            forward.png
        
          weather/
            sunny.gif
            rainy.gif
            cloudy.gif
  
Running `sprite` with no configuration file will generate the following new files:
  
    public/
      stylesheets/
        sprites.css
      images/
        sprites/
          black-icons.png
          weather.png

Any folders within `public/images/sprites/` will get compressed into a merged image file at the same 
location. Then `sprites.css` will get generated in the stylesheets folder with all the class definitions for 
these files. Just add a link to `sprites.css` into your html <head> and you're ready to go!


## CONFIGURATION ##

Configuration of `sprite` is done via `config/sprite.yml`. It allows you to set sprite configuration options, and fine tune exactly which sprites get generated where.
  
* `config:` section defines all the global properties for sprite generation. Such as how it generates the styles, where it looks for images, where it writes it output file to, and what image file format it uses by default
  - `style:` defines how the style rules are outputted. built in options are `css`, `sass`, and `sass_mixin`. (defaults to `css`)
  - `style_output_path:` defines the file path where your style settings get written (defaults to `stylesheets/sprites`). the file extension not needed as it will be set based on the `style:` setting 
  - `image_output_path:` defines the folder path where the combined sprite images files are written (defaults to `images/sprites/`)
  - `image_source_path:` defines the folder where source image files are read from (defaults to `images/`)
  - `public_path:` defines the root folder where static assets live (defaults to `public/`)
  - `sprites_class:` defines the class name that gets added to all sprite stylesheet rules (defaults to `sprites`)
  - `default_format:` defines the default file image format of the generated files. (defaults to `png`)
  - `default_spacing:` defines the default pixel spacing between sprites (defaults to 0)
  - `class_separator:` used to generated the class name by separating the image name and sprite name (defaults to `-`)

* `images:` section provides an array of configurations which define which image files are built, and where they get their sprites from. each image setup provides the following config options:
  - `name:` name of image (required)
  - `sources:` defines a list of source image filenames to build the target image from (required). They are parsed by <code>Dir.glob</code>
  - `align:` defines the composite gravity type, horizontal or vertical. (defaults to `vertical`)
  - `spaced_by:` spacing (in pixels) between the combined images. (defaults to `0`)
  - `format:` define what image file format gets created (optional, uses `default_format` setting if not set)

All image and style paths should be set relative to the public folder (which is configurable via public_path setting).

### Sample Configuration `config/sprite.yml` ###

    # defines the base configuration options (file paths, etc, default style, etc)

    config:
      style: css
      style_output_path: stylesheets/sprites
      image_output_path: images/sprites/
      image_source_path: images/
      public_path: public/
      sprites_class: 'sprites'
      class_separator: '-'
      default_format: png
      default_spacing: 50
    
    # defines what sprite collections get created
    images:    

      # creates a public/images/sprites/blue_stars.png image with 4 sprites in it
      - name: blue_stars
        format: png
        align: horizontal
        spaced_by: 50
        sources:
          - icons/blue-stars/small.png
          - icons/blue-stars/medium.png
          - icons/blue-stars/large.png
          - icons/blue-stars/xlarge.png
      
      # creates a public/images/sprites/green-stars.jpg image with 
      # all the gif files contained within /images/icons/green-stars/
      - name: green_stars
        format: png
        align: vertical
        spaced_by: 50
        sources:
          - icons/green-stars/*.gif

### Style Settings ###

By default, it will use with `style: css` and generate the file at `public/stylesheets/sprites.css`

    .sprites.blue-stars-small {
      background: url('/images/icons/blue-stars/small.png') no-repeat 0px 0px;
      width: 12px;
      height: 6px;
    }
    .sprites.blue-stars-medium {
      background: url('/images/icons/blue-stars/medium.png') no-repeat 0px 6px;
      width: 30px;
      height: 15px;
    }
    .sprites.blue-stars-large {
      background: url('/images/icons/blue-stars/large.png') no-repeat 0px 21px;
      width: 60px;
      height: 30px;
    }
    .sprites.blue-stars-xlarge {
      background: url('/images/icons/blue-stars/xlarge.png') no-repeat 0px 96px;
      width: 100px;
      height: 75px;
    }

We also support mixin syntax via `style: sass_mixin`. If set, it will generate a SASS mixin which you can use in order to mix in these sprites anywhere within your SASS stylesheets. For this option, set `style_output_path:` to `stylesheets/sass/_sprites` in order to generate the sass mixin file at `stylesheets/sass/_sprites.sass`
    
    @import "sass/mixins/sprites.sass"
    
    // you can then use your sprite like this
    .largebluestar
      +sprite("blue-stars", "large")

    .mysmallbluestar
      +sprite("blue-stars", "small")
      
Additional style generators are very easy to add. We have one for `style: sass` and `style: sass_ext`. The `sass_ext` style is a work in progress, as it's attempting to write the sprite data to yml and use a dynamic sass extension to provide the mixin. Eventually, if it works, this will be the default for `sass_mixin`
      
## Framework Integration?? ##

`sprite` is provided as a command line helper. Deep web framework integration is not implemented at this time, however it shouldn't be needed. Just generate your sprites on your dev machine by running the command line, check in the resulting sprite images and stylesheets to your source control, and deploy!

You can also easily script it out via capistrano. You could also run `sprite` on application start, or just about anywhere. Let me know what limitations you run into.

## ABOUT `sprite` ##

`sprite` was originally based off of Richard Huang's excellent Rails plugin: [css_sprite](http://github.com/flyerhzm/css_sprite)

Since then it's been rebuilt (with some reuse of the image generation code) to be a general purpose ruby executable, with hooks for merb/rails/sinatra


## LICENSE  ##

Released under the MIT License

## COPYRIGHT ##

Copyright (c) 2009 Gist

Original Codebase Copyright (c) 2009 [Richard Huang]
