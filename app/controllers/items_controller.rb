class ItemsController < ApplicationController

  def update
    item = Item.find(params[:id])
    if item && item.update(params)
      render status: :ok, json: item
    end
  end

  def create
    item = Item.new(params)
    if item.create
      render status: :ok, json: item
    else
      
    end
  end
end
