class Picture < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # ASSOCIATIONS
  # ------------------------------------------------------------------------------------------------------
	belongs_to :picturable, polymorphic: true
  acts_as_list scope: :picturable


  # ATTRIBUTES
  # ------------------------------------------------------------------------------------------------------
  has_attached_file :upload,
                    url: "/upload/pictures/:id/:style/:basename.:extension",
                    path: ":rails_root/public/upload/pictures/:id/:style/:basename.:extension",
                    quality: 70,
                    styles: { thumb: "200x200#", large: "700" }


  # VALIDATIONS
  # ------------------------------------------------------------------------------------------------------
  validates_attachment_size :upload, less_than: 5.megabytes
  validates_attachment_content_type :upload, content_type: ['image/jpeg', 'image/jpg', 'image/png', 'image/gif']


  # CALLBACKS
  # ------------------------------------------------------------------------------------------------------
  before_save :set_name


  # INSTANCE METHODS
  # ------------------------------------------------------------------------------------------------------
  def to_jq_upload
    {
      "id"            => id,
      "name"          => name,
      "size"          => upload_file_size,
      "url"           => upload.url(:original),
      "thumbnail_url" => upload.url(:thumb),
      "edit_url"      => polymorphic_path([:edit, :admin, picturable, self]),
      "delete_url"    => polymorphic_path([:admin, picturable, self]),
      "delete_type"   => "DELETE"
    }
  end

  def set_name
    self.name = name.blank? ? File.basename(upload_file_name, ".*") : name
  end

  def self.color_ordered(color_id)
    all.sort { |picture_1, picture_2| picture_1.colors.where(search_color_id: color_id).exists? ? -1 : 1 }
  end

end
