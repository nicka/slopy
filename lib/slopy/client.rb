module Slopy
  extend self

  def next
    run 'next track'
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
  end

  def previous
    run 'previous track'
  end

  def repeat
    toggle 'repeating'
  end

  def shuffle
    toggle 'shuffling'
  end

  def start
    run 'play track "spotify:user:nickdenengelsman:playlist:52lnlHQ4F8rve2nJY1wgZa"'
  end

  def volume(to)
    run "set sound volume to #{to.to_i}"
  end

  private

  def run(command)
    # log_command command
    `osascript -e 'tell application \"Spotify\" to #{command}'`
  end

  def toggle(command)
    # log_command command
    shuffle_command = %Q{
      tell application "Spotify"
        if #{command} is false then
          set #{command} to true
        else
          set #{command} to false
        end if
      end tell
    }
    system "osascript -e '#{shuffle_command}'"
  end

  def log_command(command)
    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] COMMAND  toggle #{command}"
  end
end
