require 'open-uri'

# Opens a file from a url then parses each line and turns it into a
#   JSON Dictionary and stores the JSON in a DynamoDB NoSQL Database
class ParserService
  attr_reader :url
  attr_accessor :results

  def initialize(url)
    @url = url
    @results = { 'success' => 0, 'failed' => 0 }
  end

  def upload_file
    raise ArgumentError, 'URL is not valid' unless url_valid?
    open(url) do |f|
      f.each_line do |line|
        # Parse line and convert to a hash
        hashed_line = hashify(line)
        # Init a new item to store
        item = Item.new(hashed_line)
        # Save the item and store the results
        item.create ? results['success'] += 1 : handle_errors(item)
      end
    end
    results
  end

  def hashify(line)
    # From Squish - Rails method remove whitespace, /n, and change /t to a space
    line.gsub!(/\A[[:space:]]+/, '')
    line.gsub!(/[[:space:]]+\z/, '')
    line.gsub!(/[[:space:]]+/, ' ')

    # Split formated string into id and body
    elements = line.split(' ', 2)
    return nil unless elements.length == 2

    # Return the correctly formatted hash
    { 'id' => JSON.parse(elements[0]) }.merge(JSON.parse(elements[1]))
  end

  private

  def url_valid?
    uri = URI.parse(url)
    %w(http https).include?(uri.scheme)
  end

  # Attempts to save the items and tracks the number of successes or failures
  def handle_errors(item)
    # Need to track the errors
    item.errors.values.each do |msg|
      results['failed'] += 1
      results.key?(msg[0]) ? results[msg[0]] += 1 : results[msg[0]] = 1
    end
  end
end
