# frozen_string_literal: true

require 'holidays'

class Moment
  attr_reader :time, :type

  def initialize(time, type)
    @time = time
    @type = type
  end

  def skip?
    past? || holiday? || weekend?
  end

  private

  def past?
    @time < Time.now
  end

  def holiday?
    Holidays.on(@time, *holiday_config).any?
  end

  def weekend?
    @time.saturday? || @time.sunday?
  end

  def holiday_config
    [].tap do |config|
      config << default_config.holidays_region
      config << :observed if default_config.holidays_observed
    end
  end

  def default_config
    Config.instance.default
  end
end
