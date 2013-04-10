module ActiveRecord
  class Base
    before_validation(:_clean_whitespace)
    
    def _clean_whitespace
      self.attributes.each_pair do |key, value|
        self[key] = value.strip if value.respond_to?('strip')
      end
    end
  end
end