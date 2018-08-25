require "enum_site_setting"

module Mingle
  class IntervalOptions < EnumSiteSetting
    def self.valid_value?(val)
      values.any? { |v| v[:value].to_s == val.to_s }
    end

    def self.values
      @values ||= [
        { name: 'mingle.interval_days', value: 'days' },
        { name: 'mingle.interval_weeks', value: 'weeks' },
        { name: 'mingle.interval_months', value: 'months' }
      ]
    end

    def self.translate_names?
      true
    end
  end
end
