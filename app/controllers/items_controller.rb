class ItemsController < ApplicationController
  def update
    item = Item.find(params[:id])
    if item && item.update(params[:item])
      render status: :ok, json: item
    end
  end

  def create
    item = Item.new(params[:item])
    if item.create
      render status: :ok, json: item
    else
      
    end
  end

  def upload
    url = params[:url]
    results = ParserService.new(url).upload_file
  end
end
