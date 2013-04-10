class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
	belongs_to :picturable, polymorphic: true

  attr_accessible :name, :image

  has_attached_file :image, 
                    :url => "/upload/pictures/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/upload/pictures/:id/:style/:basename.:extension",
                    :styles => { :thumb => "100x100>" }
  
  before_create :default_name
  
  def default_name
    self.name ||= File.basename(image_file_name, '.*').titleize if image
  end

  def to_jq_upload
    {
      "name" => read_attribute(:image_file_name),
      "size" => read_attribute(:image_file_size),
      "url" => image.url(:original),
      "delete_url" => admin_picture_path(self),
      "delete_type" => "DELETE" 
    }
  end

end