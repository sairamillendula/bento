module Enumerable
  def find_dups
    inject({}) {|h,v| h[v]=h[v].to_i+1; h}.reject{|k,v| v==1}.keys
  end
end

class Object
  def try_with_default(*a, default_value, &b)
    if a.empty? && block_given?
      yield self
    else
      __send__(*a, &b) || default_value
    end
  end
end
