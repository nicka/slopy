desc 'Start Slopy'
task :start do
  puts 'Starting Slopy...'
  begin
    `rackup config.ru >> slopy.log 2>&1 &`
  rescue SignalException
  end
end

desc 'Stop Slopy'
task :stop do
  puts 'Stopping Slopy...'
  `ps aux | grep rackup | grep -v grep | awk '{ print $2 }' | xargs kill`
  sleep 2
end

desc 'Restart Slopy'
task restart: [:stop, :start]
