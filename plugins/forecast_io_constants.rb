module ForecastIOConstants
  def key
    'weather'
  end

  def scale
    'f'
  end

  def ansi_chars
    %w[_ ▁ ▃ ▅ ▇ █]
  end

  def ozone_chars
    %w[・ o O @ ◎ ◉]
  end

  def ascii_chars
    %w[_ . - ~ * ']
  end

  def get_rain_range_colors
    { 0..0.10    => :blue,
      0.11..0.20 => :purple,
      0.21..0.30 => :teal,
      0.31..0.40 => :green,
      0.41..0.50 => :lime,
      0.51..0.60 => :aqua,
      0.61..0.70 => :yellow,
      0.71..0.80 => :orange,
      0.81..0.90 => :red,
      0.91..1    => :pink
    }
  end

  def get_rain_intensity_range_colors
    { 0..0.0050      => :blue,
      0.0051..0.0100 => :purple,
      0.0101..0.0130 => :teal,
      0.0131..0.0170 => :green,
      0.0171..0.0220 => :lime,
      0.0221..0.0280 => :aqua,
      0.0281..0.0330 => :yellow,
      0.0331..0.0380 => :orange,
      0.0381..0.0430 => :red,
      0.0431..1      => :pink
    }
  end

  def get_temp_range_colors
    # Absolute zero?  You never know.
    { -459.7..24.99 => :blue,
      25..31.99     => :purple,
      32..38        => :teal,
      38..45        => :green,
      45..55        => :lime,
      55..65        => :aqua,
      65..75        => :yellow,
      75..85        => :orange,
      85..95        => :red,
      95..159.3     => :pink
    }
  end

  def get_wind_range_colors
    {   0..3    => :blue,
        3..6    => :purple,
        6..9    => :teal,
        9..12   => :aqua,
        12..15  => :yellow,
        15..18  => :orange,
        18..21  => :red,
        21..999 => :pink,
    }
  end

  def get_sun_range_colors
    { 0..0.20    => :green,
      0.21..0.50 => :lime,
      0.51..0.70 => :orange,
      0.71..1 => :yellow
    }
  end
end
