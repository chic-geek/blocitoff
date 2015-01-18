class ItemsController < ApplicationController
  def new
    @item = Item.new
  end

  def create
    @list = List.find(params[:id])
    @item = List.new(params.require(:item).permit(:name))
    if @item.save
      redirect_to [@list, @item], :notice =>  "Your to-do was created."
    else
      render "new"
    end
  end
end
