require 'open-uri'

# Opens a file from a url then parses each line and turns it into a
#   JSON Dictionary
class ParserService
  attr_reader :url

  def initialize(url)
    @url = url
  end

  # def upload_file
  #   raise ArgumentError, 'URL is not valid' unless url_valid?
  #   open(url) do |f|
  #     t = 0
  #     f.each_line do |line|
  #       # Parse line and convert to a hash
  #       hashed_line = hashify(line)
  #
  #       if t < 10
  #         item = Item.new(hashed_line)
  #         if item.create
  #           # TODO: need to track stuff
  #         else
  #           puts item.errors.full_messages
  #         end
  #       end
  #       p hashed_line
  #       t += 1
  #     end
  #     p "Total lines = #{t}"
  #   end
  # end

  def upload_file
    raise ArgumentError, 'URL is not valid' unless url_valid?
    open(url) do |f|
      t = 0
      f.each_line do |line|
        # Parse line and convert to a hash
        hashed_line = hashify(line)
        # Create a new item to store
        item = Item.new(hashed_line)
        item.create ? t += 1 : item.errors.full_messages
      end
    end
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
end
