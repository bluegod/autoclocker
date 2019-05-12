# frozen_string_literal: true

require 'concurrent-ruby'
require 'time'

class Scheduler
  include SemanticLogger::Loggable

  def initialize
    reset_moments
  end

  def run
    @moments.each do |moment|
      next if moment.skip?

      logger.info("Scheduling clock #{moment.type} at #{moment.time}")

      Concurrent::Promises.schedule(moment.time) do
        Api::Clocker.new.public_send(moment.type)
      end
    end

    sleep(tomorrow - Time.now)
    reset_moments
    run
  end

  private

  def reset_moments
    @moments = [
      Moment.new(Time.parse(config.default.clock_in_time), :in),
      Moment.new(Time.parse(config.default.clock_out_time), :out)
    ]
  end

  def config
    Config.instance
  end

  def tomorrow
    (Date.today + 1).to_time + 1
  end
end
