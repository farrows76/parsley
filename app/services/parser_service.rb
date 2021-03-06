require 'open-uri'
require 'json'

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
        # Attempts to save the item and tracks the number of successes or failures
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
    { 'id' => elements[0].gsub!(/\A"|"\Z/, '') }.merge(JSON.parse(elements[1]))
  end

  private

  def url_valid?
    uri = URI.parse(url)
    %w(http https).include?(uri.scheme)
  end

  def handle_errors(item)
    # Tracks the number that failed and error responses
    results['failed'] += 1
    item.errors.values.each do |msg|
      results.key?(msg[0]) ? results[msg[0]] += 1 : results[msg[0]] = 1
    end
  end
end
