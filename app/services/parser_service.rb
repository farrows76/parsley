require 'open-uri'
# Opens a file from a url then parses each line and turns it into a JSON Dictionary
# Example URL: https://gist.githubusercontent.com/fcastellanos/86f02c83a5be6c7a30be390d63057d7d/raw/b25c562a6823a26a700a7ea08004c456ad8e2184/output

class ParserService
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def parse
    raise ArgumentError, 'URL is not valid' unless url_valid?
    open(url) do |f|
      t = 0
      f.each_line do |line|
        # Parse line and convert to a hash
        hashed_line = convert_to_hash(line)

        if t < 10
          item = Item.new(hashed_line)
          unless item.create
            puts item.errors.full_messages
          else
            
          end
        end
        p hashed_line
        t += 1
      end
      p "Total lines = #{t}"
    end
  end

  private

  def url_valid?
    uri = URI.parse(url)
    %w(http https).include?(uri.scheme)
  end

  def convert_to_hash(line)
    # From Squish - Rails method remove whitespace, /n, and change /t to a space
    line.gsub!(/\A[[:space:]]+/, '')
    line.gsub!(/[[:space:]]+\z/, '')
    line.gsub!(/[[:space:]]+/, ' ')

    # Split formated string into id and body
    elements = line.split(' ', 2)
    return nil unless elements.length == 2

    # Return the correctly formatted hash
    { "id" => JSON.parse(elements[0]) }.merge(JSON.parse(elements[1]))
  end
end