lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'slopy'
require 'dotenv'
Dotenv.load

if ENV['RUNNER'] == 'sqs'
  sqs = Slopy::SQS.new
  sqs.poll
else
  run Slopy::API
end
