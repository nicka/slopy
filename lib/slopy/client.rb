require 'slopy/sqs'

module Slopy
  extend self

  def next
    run 'next track'
    current_track
  end

  def pause
    run 'pause'
  end

  def play(url=nil)
    if url.nil?
      run 'play'
    else
      run "play track \"#{url}\""
    end
    current_track
  end

  def playing?
    current_track
  end

  def previous
    run 'previous track'
    current_track
  end

  def repeat
    toggle 'repeating'
  end

  def shuffle
    toggle 'shuffling'
  end

  def start
    run "play track \"#{ENV['DEFAULT_PLAYLIST_URL']}\""
  end

  def volume(to)
    run "set sound volume to #{to.to_i}"
  end

  private

  def run(command)
    `osascript -e 'tell application \"Spotify\" to #{command}'`
  end

  def current_track
    command = %Q{
      tell application "Spotify"
        # set currentArtwork to artwork of current track as string
        set currentArtist to artist of current track as string
        set currentTrack to name of current track as string
        return currentArtist & " - " & currentTrack
      end tell
    }
    output = %x[osascript -e '#{command}']
    push "Now playing: #{output}"
  end

  def toggle(command)
    shuffle_command = %Q{
      tell application "Spotify"
        if #{command} is false then
          set #{command} to true
          return "enabled"
        else
          set #{command} to false
          return "disabled"
        end if
      end tell
    }
    output = %x[osascript -e '#{shuffle_command}']
    push "#{command.camelize} #{output}"
  end

  def push(message)
    if ENV['RUNNER'] == 'sqs'
      sqs = Slopy::SQS.new
      sqs.push message.strip
    end
  end
end