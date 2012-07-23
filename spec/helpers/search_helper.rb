module SearchHelper
  def stub_nil_results
    connection.response = { 'response' => nil }
  end

  def stub_full_results(*results)
    count =
      if results.last.is_a?(Integer) then results.pop
      else results.length
      end
    docs = results.map do |result|
      instance = result.delete('instance')
      result.merge('id' => "#{instance.class.name} #{instance.id}")
    end
    response = {
      'response' => {
        'docs' => docs,
        'numFound' => count
      }
    }
    connection.response = response
    response
  end

  def stub_results(*results)
    stub_full_results(
      *results.map do |result|
        if result.is_a?(Integer)
          result
        else
          { 'instance' => result }
        end
      end
    )
  end

  def stub_stat(name, values)
    connection.response = {
      'facet_counts' => {
        'facet_fields' => {
          name.to_s => values.to_a.sort_by { |value, count| -count }.flatten
        }
      }
    }
  end

  def stat_field_name(result, field_name)
    result.stat(field_name).rows.map { |row| row.field_name }
  end

  def values(result, field_name)
    result.stat(field_name).rows.map { |row| row.value }
  end
  
end