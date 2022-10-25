class FileSizeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    max = options.fetch(:max, 5.megabytes)
    file_size = value.blob.byte_size

    return if file_size <= max

    message = "size must be less than #{max / Numeric::MEGABYTE}MB"
    record.errors.add(attribute, message)
  end
end
