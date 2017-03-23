##
# Handles the API requests
class ItemsController < ApplicationController
  def update
    # TODO: Need to add item not found render
    item = Item.find(params[:id])
    if item && item.update(params[:item])
      render status: :ok, json: item
    else
      render status: :unprocessable_entity, json: item.errors
    end
  end

  def create
    item = Item.new(params[:item])
    if item.create
      render status: :ok, json: item
    else
      render status: :unprocessable_entity, json: item.errors
    end
  end

  def upload
    url = params[:url]
    results = ParserService.new(url).upload_file
    render status: :ok, json: results
  end
end
