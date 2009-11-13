# sprite #

`sprite` is a gem that helps generate css sprite images automagically. It's aim is to support all web frameworks (Merb/Rails/Sinatra)

it's a fork an extension of Richard Huang's excellent Rails plugin `css_sprite` (github.com/flyerhzm/css_sprite)

****

## Install ##

install rmagick gem first:

    gem install rmagick

if you have any problems with the rmagick gem, install imagemagick via macports first:

    sudo port install libxml2
    sudo port install ImageMagick  

or via installer: http://github.com/maddox/magick-installer/tree/master

install it as a gem:

    gem sources -a http://gemcutter.org
    gem install sass_sprite

### if using merb ###
  
    gem "sprite"
  
### if using rails ###

    script/plugin install git://github.com/merbjedi/sprite.git

or add to environment.rb
    
    config.gem "sprite"

***

## Configuration ##

add `config/sprite.yml`, define about compositing what images.

  forum_icon_vertical.gif:  # destination image file
    sources:                # source image file list
      - good_topic.gif
      - mid_topic.gif
      - unread_topic.gif
      - sticky_topic.gif
    orient: vertical        # composite gravity, vertical or horizontal
    span: 5                 # span of space between two images

first line defines the destination image filename.
`sources` is a list of source image filenames what want to composite. They are parsed by <code>Dir.glob</code>.
`orient` defines the composite gravity type, horizontal or vertical. Default is 'vertical'.
`span` defines the span between two images. Default is 0.

you can define any number of destination image files.

***

## Usage ##

if you use it as a gem, add a task `lib/tasks/sprites.rake` first:

  require 'sprites'

if you use it as a plugin, ignore the step above.

then just run rake task:
  
  rake sprites:build

the result css is generated at `public/stylesheets/sprite.css`

    .good_topic {
        background: url('/images/forum_icon_vertical.gif') no-repeat 0px 0px;
        width: 20px;
        height: 19px;
    }
    .mid_topic {
        background: url('/images/forum_icon_vertical.gif') no-repeat 0px 24px
        width: 20px;
        height: 19px;
    }
    .unread_topic {
        background: url('/images/forum_icon_vertical.gif') no-repeat 0px 48px;
        width: 19px;
        height: 18px;
    }
    .sticky_topic {
        background: url('/images/forum_icon_vertical.gif') no-repeat 0px 71px;
        width: 19px;
        height: 18px;
    }


***

## Contributors ##

merbjedi - reorganized as a general purpose ruby plugin for merb/rails/sinatra/
josedelcorral - fix the style of generated css

***


Copyright (c) 2009 [Richard Huang (flyerhzm@gmail.com)], released under the MIT license
