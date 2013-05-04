class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
	belongs_to :picturable, polymorphic: true
  acts_as_list scope: :picturable

  attr_accessible :upload, :name

  has_attached_file :upload, 
                    :url => "/upload/pictures/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/upload/pictures/:id/:style/:basename.:extension",
                    :styles => { :thumb => "200x150>" }

  before_save :set_name                  
  
  def to_jq_upload
    {
      "id" => id,
      "name" => name,
      "size" => upload_file_size,
      "url" => upload.url(:original),
      "thumbnail_url" => upload.url(:thumb),
      "edit_url" => polymorphic_path([:edit, :admin, picturable, self]),
      "delete_url" => polymorphic_path([:admin, picturable, self]),
      "delete_type" => "DELETE" 
    }
  end

  def set_name
    self.name = name.blank? ? File.basename(upload_file_name, ".*") : name
  end

end