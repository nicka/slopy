require 'aws-sdk'
require 'json'
require 'shellwords'

module Slopy
  class SQS

    def initialize
      Aws.config.update({
        region: 'eu-west-1',
        credentials: Aws::Credentials.new(ENV['SQS_ACCESS_KEY_ID'], ENV['SQS_SECRET_ACCESS_KEY_ID'])
      })
    end

    def push(options)
      sqs = Aws::SQS::Client.new
      msg = sqs.send_message({
        queue_url: ENV['SQS_HUBOT_QUEUE_URL'],
        message_body: options
      })
    end

    def poll
      poller = Aws::SQS::QueuePoller.new(ENV['SQS_SLOPY_QUEUE_URL'])
      poller.poll do |msg|
        json = JSON.parse(msg.body)
        puts "Incoming hubot SQS message: #{json}"
        if json.key?('method') && json['method'] == 'say'
          Slopy.pause
          `say #{Shellwords.escape(json['options']['params'])}`
          Slopy.play
        elsif json.key?('method') && json['method'] == 'volume'
            set_volume = json['options']['params'].to_s.empty? ? 75 : json['options']['params'].to_i
            Slopy.volume(set_volume)
        else
          Slopy.send(json['method']) if json.key?('method')
        end
      end
    end
  end
end
