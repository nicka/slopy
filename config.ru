lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'slopy'
require 'dotenv'
Dotenv.load

if ENV['RUNNER'] == 'sqs'
  Thread.new do
    while true
      begin
        Slopy.check_current
      rescue => e
         $stderr.puts e.message
         $stderr.puts e.backtrace.join("\n")
      end

      sleep 1
    end
  end.run
  sqs = Slopy::SQS.new
  sqs.poll
else
  run Slopy::API
end
