class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers
	belongs_to :picturable, polymorphic: true

  attr_accessible :name, :upload

  has_attached_file :upload, 
                    :url => "/upload/pictures/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/upload/pictures/:id/:style/:basename.:extension",
                    :styles => { :thumb => "100x100>" }
  
  # before_create :default_name
  
  # def default_name
  #   self.name ||= File.basename(upload_file_name, '.*').titleize if upload
  # end

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