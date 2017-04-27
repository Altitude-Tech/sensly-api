require 'sensly/sensors/base_sensor'

module Sensly
  ##
  # Base MQ sensor class.
  ##
  class MQSensor < BaseSensor
    ##
    # Value of the load reistor in Ohms.
    ##
    R_LOAD = 10_000.0

    def initialize(adc_value, r0, temperature, humidity)
      super adc_value

      @r0 = Float(r0)
      @temperature = Float(temperature)
      @humidity = Float(humidity)
    end

    ##
    # Convert a raw ADC value to resistance of the sensor.
    ##
    def adc_to_rs
      return ((MAX_ADC / @adc_value) - 1.0) * R_LOAD
    end

    ##
    # Calculates the ratio of the sensor resistance (Rs) to the base resistance (R0)
    ##
    def rs_ro_ratio
      return adc_to_rs / @r0
    end

    ##
    # Get the corrected RsR0 value.
    ##
    def corr_rs_ro_ratio
      return @rs_ro_ratio
    end

    ##
    # Calculate the ambient temperature for a relative humidity
    ##
    def amb_temp_at_rel_humidity(coeff)
      return (coeff[0] * (@temperature**3)) +
             (coeff[1] * (@temperature**2)) +
             (coeff[2] * @temperature) +
             coeff[3]
    end

    ##
    #
    ##
    def gases
      self.class::GAS_CONFIG.each do |k, v|
        next if v[:min] > corr_rs_ro_ratio
        next if v[:max] < corr_rs_ro_ratio

        data = {}

        data[:ppm] = 10**((v[:gradient] * Math.log10(@rs_ro_ratio)) + v[:intercept])
        data[:name] = Sensly.gas_name(k)

        yield data
      end
    end
  end
end
