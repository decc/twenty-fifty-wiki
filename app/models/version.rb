class Version < ActiveRecord::Base
  belongs_to :target, :polymorphic => true
  belongs_to :user
  belongs_to :signed_off_by, :class_name => 'User'  
  belongs_to :previous_version, :class_name => "Version"
  belongs_to :cost_category
  belongs_to :cost_source
  
  scope :recent, order('updated_at DESC').limit(50).includes(:target,:user)
  
  has_attached_file :picture
  has_attached_file :attachment, :styles => {}, :convert_options => nil
  
  def self.versioned_attributes
    @versioned_attributes ||= %w{title content user_id picture medium_picture_width medium_picture_height picture_updated_at signed_off_by_id signed_off_at cost_category_id cost_source_id valid_for_quantity_of_fuel valid_in_year efficiency life size fuel operating capital default_fuel_unit default_operating_unit default_capital_unit label output attachment_file_name attachment}.map(&:to_sym)
  end
  
  def Version.create_from(target)
    v = Version.new :target => target, :previous_version => target.versions.last
    Version.versioned_attributes.each do |attribute|
      next unless target.respond_to?(attribute)
      v.send "#{attribute}=", target.send(attribute)
    end
    # Need to manually assign the picture attribute, due to a paperclip bug
    if target.respond_to?(:picture) && target.picture.present?
      v.picture = target.picture
    end
    if target.respond_to?(:attachment) && target.attachment.present?
      v.attachment = target.attachment
    end
    v.save
    v
  end
  
  def revert_target_to_this_version
    Version.versioned_attributes.each do |attribute|
      next unless target.respond_to?("#{attribute}=")
      target.send "#{attribute}=", send(attribute)
    end
  end
  
  def to_comparable_text
    Version.versioned_attributes.map do |attribute|
      if target.respond_to?(attribute)
        if attribute =~ /^(.*?)_id$/i
          "#{attribute.to_s.humanize}: #{send($1).try(:title)}"
        else
          "#{attribute.to_s.humanize}: #{send(attribute)}"
        end
      else
        nil
      end
    end.compact.join("\n\n")
  end
  
end
