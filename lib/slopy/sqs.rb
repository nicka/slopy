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
          say(json['options']['params'])
        elsif json.key?('method') && json['method'] == 'sing'
          say(json['options']['params'], 'Good')
        elsif json.key?('method') && json['method'] == 'cellos'
          say(json['options']['params'], 'Cellos')
        elsif json.key?('method') && json['method'] == 'volume'
            set_volume = json['options']['params'].to_s.empty? ? 75 : json['options']['params'].to_i
            Slopy.volume(set_volume)
        elsif json.key?('method') && json['method'] == 'play'
          Slopy.play(json['options']['params'])
        else
          Slopy.send(json['method']) if json.key?('method')
        end
      end
    end

    def say(what, voice = nil)
      cmd = "say"
      cmd += " -v #{Shellwords.escape(voice)}" if voice.to_s.length > 0
      cmd += " #{Shellwords.escape(what)}"

      Slopy.pause
      `#{cmd}`
      Slopy.play
    end
  end
end
