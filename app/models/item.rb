class Item
  # Required dependency for ActiveModel::Errors
  extend ActiveModel::Naming

  # {"id"=>"905772", "sharing_settings"=>{"publish_track_actions"=>"false", "publish_rsvp_actions"=>"true", "notification_settings"=>{"just_announced"=>"false", "friend_comment"=>"true"}}}

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

  def data_attributes
    tmp_data = Hash.new()
    data.each do |key, value|
      tmp_data[key] = { "Action" => "PUT", "Value" => value } unless key == "id"
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
    response.item
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def create
    return false unless valid?(data)
    dynamodb.put_item(
      table_name: "Bandsintown",
      item: data,
      condition_expression: 'attribute_not_exists(id)'
    )
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def update(attributes)
    return false unless valid?(attrubutes)
    self.data.merge!(attrubutes)
    dynamodb.update_item(
      table_name: "Bandsintown",
      key: { 'id' => id },
      attribute_updates: data_attributes,
      return_values: 'UPDATED_NEW'
    )
  rescue Aws::DynamoDB::Errors::ServiceError => e
    handle_error(e)
  end

  def valid?(attributes)
    return true if attributes.has_key?('id')
    errors.add(:data, message: "incorrect format of data") and return false
  end

  def truthify_hash(hash)
    # Recursively go through the hash and and convert truth strings to booleans
    hash.each do |key, value|
      truthify_hash(value) if value.is_a? Hash
      hash[key] = true if value == "true"
      hash[key] = false if value == "false"
    end
  end

  def handle_error(e)
    errors.add(:data, message: e.message) and return false
  end

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