##
# Represents a data hash object that is can be stored in a DynamoDB
# NoSql Database.
class Item
  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  def initialize(data = {})
    @data = truthify_hash(data)
    @dynamodb = Aws::DynamoDB::Client.new
    @errors = ActiveModel::Errors.new(self)
  end

  attr_accessor :data
  attr_reader :dynamodb, :errors

  def data=(val)
    @data = truthify_hash(val)
  end

  def attributes_to_update
    tmp_data = {}
    data.each do |key, value|
      tmp_data[key] = { action: 'PUT', value: value } unless key == 'id'
    end
    tmp_data
  end

  def self.find(id)
    dynamodb = Aws::DynamoDB::Client.new
    response =
      dynamodb.get_item(
        table_name: 'Bandsintown',
        key: { 'id' => id }
      )
    response.item ? Item.new(response.item) : nil
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def create
    return false unless valid?(data)
    dynamodb.put_item(
      table_name: 'Bandsintown',
      item: data,
      condition_expression: 'attribute_not_exists(id)'
    )
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def update(attributes)
    return false unless valid?(attributes)
    data.merge!(truthify_hash(attributes)) # make sure we truthify the updated attributes
    dynamodb.update_item(
      table_name: 'Bandsintown',
      key: { id: data['id'] },
      attribute_updates: attributes_to_update
    )
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def truthify_hash(hash)
    # Recursively go through the hash and and convert truth strings to booleans
    hash.each do |key, value|
      truthify_hash(value) if value.is_a? Hash
      hash[key] = true if value == 'true'
      hash[key] = false if value == 'false'
    end
  end

  def valid?(attributes)
    # Checks to make sure the data is in the proper format and includes the
    #   id Primary Key
    return true if (attributes.is_a? Hash) && attributes.key?('id')
    errors.add(:data, :invalid, message: 'Incorrect format of data')
    false # is not valid
  end

  def handle_error(e)
    errors.add(:data, :invalid, message: e.message)
    false # did not save
  end

  # Required for active model errors integration
  def read_attribute_for_validation(attr)
    send(attr)
  end

  def self.human_attribute_name(attr, options = {})
    attr
  end

  def self.lookup_ancestors
    [self]
  end
end
