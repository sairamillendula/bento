class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
	belongs_to :picturable, polymorphic: true
  acts_as_list scope: :picturable

  attr_accessible :upload

  has_attached_file :upload, 
                    :url => "/upload/pictures/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/upload/pictures/:id/:style/:basename.:extension",
                    :styles => { :thumb => "200x150>" }
  
  def to_jq_upload
    {
      "name" => read_attribute(:upload_file_name),
      "size" => read_attribute(:upload_file_size),
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:thumb),
      "delete_url" => polymorphic_path([:admin, picturable, self]),
      "delete_type" => "DELETE" 
    }
  end

end