module Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :format_slug
  end

  def format_slug
    slug.parameterize.downcase
  end
end