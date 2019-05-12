# frozen_string_literal: true

require 'rubygems'
require 'faraday'
require 'faraday_middleware'

module Api
  class Clocker
    include SemanticLogger::Loggable

    def initialize
      logger.measure_info 'Calling auth API' do
        @slack = Slack.new
        @auth_config = Api::Auth.new.to_hash
        @slack.name = @auth_config[:name]
      end
    rescue StandardError => e
      @slack&.other_error(e.message)

      raise
    end

    def in
      logger.measure_info 'Clocking in' do
        # FIXME
        @auth_config[:token_conn].get("time-and-attendance/clocking/#{@auth_config[:id]}/check-visibility")
        @slack.clock_in
      end
    rescue StandardError => e
      @slack.clock_in_error(e.message)

      raise
    end

    def out
      logger.measure_info 'Clocking out' do
        # FIXME
        @auth_config[:token_conn].get("time-and-attendance/clocking/#{@auth_config[:id]}/check-visibility")
        @slack.clock_out
      end
    rescue StandardError => e
      @slack.clock_out_error(e.message)

      raise
    end
  end
end
