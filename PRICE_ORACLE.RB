class PriceOracle
  def initialize
    @prices = {}
    @sources = []
  end

  def add_data_source(source)
    @sources << source unless @sources.include?(source)
  end

  def update_price(symbol, value)
    @prices[symbol] = {
      value: value.to_f,
      timestamp: Time.now.to_i
    }
  end

  def get_price(symbol)
    return nil unless @prices[symbol]
    @prices[symbol]
  end

  def aggregate_price(symbol, sources)
    values = sources.map { |s| s.get_price(symbol)&.dig(:value) }.compact
    return 0.0 if values.empty?
    values.sum / values.length.to_f
  end
end
