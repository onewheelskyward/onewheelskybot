class GoogleAbstract
  def get_index(query)
    index = 0
    if query =~ /\[(\d+)\]$/
      query.gsub! /\[(\d+)\]$/, ''
      index = $1.to_i
    end
    index
  end

  def api_call(url)
    agent = Mechanize.new
    result = agent.get(url)
    result.body
  end
end