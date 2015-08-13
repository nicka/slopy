require 'grape'
require 'slopy/client'

module Slopy
  class API < Grape::API
    version 'v1', using: :header, vendor: 'slopy'
    format :json
    prefix :api

    desc 'Next song'
    get :next do
      Slopy.next
      { status: 200, message: 'Started next song' }
    end

    desc 'Pause'
    get :pause do
      Slopy.pause
      { status: 200, message: 'Paused Spotify' }
    end

    desc 'Play'
    get :play do
      Slopy.play(params[:url])
      { status: 200, message: 'Play song' }
    end

    desc 'Previous'
    get :previous do
      Slopy.previous
      { status: 200, message: 'Started previous song' }
    end

    desc 'Repeat'
    get :repeat do
      Slopy.repeat
      { status: 200, message: 'Toggled repeat' }
    end

    desc 'Shuffle'
    get :shuffle do
      Slopy.shuffle
      { status: 200, message: 'Toggled shuffle' }
    end

    desc 'Start Spotify'
    get :start do
      Slopy.start
      { status: 200, message: 'Started Spotify' }
    end

    desc 'Volume'
    get :volume do
      Slopy.volume(params[:to])
      { status: 200, message: "Updated volume to #{params[:to]}" }
    end

    desc 'Catch all'
    route :any, '*path' do
      error!({ status: 500, message: 'Not found' }, 500)
    end
  end
end
