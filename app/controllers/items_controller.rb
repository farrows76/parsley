##
# Handles the API requests
class ItemsController < ApplicationController

  # Expects a params[:id] string in the get URL request
  #   '/parsley/find/ID'
  def find
    item = Item.find(params[:id])
    raise ActionController::RoutingError.new('Item Not Found') unless item
    render status: :ok, json: item
  end

  # Expects a params[:item] in JSON format with a minimum of an id key
  def update
    item = Item.find(params[:item][:id])
    raise ActionController::RoutingError.new('Item Not Found') unless item
    if item.update(params[:item])
      render status: :ok, json: item
    else
      render status: :unprocessable_entity, json: item.errors
    end
  end

# Expects a params[:item] in JSON format with a minimum of an id key
  def create
    item = Item.new(params[:item])
    if item.create
      render status: :ok, json: item
    else
      render status: :unprocessable_entity, json: item.errors
    end
  end

  # Expects a params[:url] String that is a correctly formatted
  #   URL of a file of items to be uploaded
  def upload
    url = params[:url]
    results = ParserService.new(url).upload_file
    render status: :ok, json: results
  end
end
