Ransack.configure do |config|
  config.add_predicate 'from',
    :arel_predicate => 'gteq',
    :formatter => proc {|v| v.to_date.to_s(:db) },
    :validator => proc {|v| v.present?},
    :compounds => true,
    :type => :date

  config.add_predicate 'to',
    :arel_predicate => 'lteq',
    :formatter => proc {|v| v.to_date.to_s(:db) },
    :validator => proc {|v| v.present?},
    :compounds => true,
    :type => :date  
end