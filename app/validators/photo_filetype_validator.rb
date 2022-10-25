class PhotoFiletypeValidator < ActiveModel::EachValidator
  ACCEPTED_CONTENT_TYPES = %w[image/jpeg image/jpg image/png].freeze

  def validate_each(record, attribute, value)
    return if ACCEPTED_CONTENT_TYPES.include?(value.blob.content_type)

    record.errors.add attribute, "is not a photo"
  end
end
