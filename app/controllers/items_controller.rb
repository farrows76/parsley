##
# Handles the API requests
class ItemsController < ApplicationController
  # Expects a params[:id] string in the get URL request
  #   '/parsley/find/ID'
  def find
    item = Item.find(params[:id])
    raise ActionController::RoutingError, 'Item Not Found' unless item
    render status: :ok, json: item.data
  end

  # Expects params in JSON format with a minimum of an id key
  def update
    item = Item.find(item_params[:id])
    raise ActionController::RoutingError, 'Item Not Found' unless item
    if item.update(item_params.to_hash)
      render status: :ok, json: item.data
    else
      render status: :unprocessable_entity, json: { error: item.errors }
    end
  end

  # Expects params in JSON format with a minimum of an id key
  def create
    item = Item.new(item_params.to_hash)
    if item.create
      render status: :ok, json: item.data
    else
      render status: :ok, json: { error: item.errors }
    end
  end

  # Expects params[:url] in JSON format that is a correctly formatted
  #   URL of a file of items to be uploaded
  def upload
    url = url_params
    results = ParserService.new(url).upload_file
    render status: :ok, json: results
  end

  private

  def item_params
    params.require(:item)
  end

  def url_params
    params.require(:url)
  end
end
