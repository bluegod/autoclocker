# frozen_string_literal: true

require 'rubygems'
require 'faraday'
require 'faraday_middleware'

module Api
  class Clocker
    include SemanticLogger::Loggable

    CLOCKING_TYPE = '2'

    def initialize(moment)
      logger.measure_info 'Calling auth API' do
        @slack = Slack.new
        @moment = moment
        @auth_config = Api::Auth.new.to_hash
        @slack.name = @auth_config[:name]
      end
    rescue StandardError => e
      logger.error(e.message, moment_type: @moment&.type, moment_time: @moment&.time_formatted)
      @slack&.other_error(e.message)

      raise
    end

    def clock!
      logger.measure_info "Clocking #{@moment.type}" do
        @auth_config[:token_conn].post("time-and-attendance/clocking/#{@auth_config[:id]}/post", clock_attributes)
        @slack.public_send("clock_#{@moment.type}")
      end
    rescue StandardError => e
      logger.error(e.message, moment_type: @moment.type, moment_time: @moment.time_formatted)
      @slack.public_send("clock_#{@moment.type}_error", e.message)

      raise
    end

    private

    def clock_attributes
      {
        badge_id: Config.instance.default[:location],
        clocking_type: CLOCKING_TYPE,
        event_time: @moment.time_formatted,
        event_type: event_type.to_s
      }
    end

    def event_type
      @moment.type == :in ? 0 : 1
    end
  end
end
