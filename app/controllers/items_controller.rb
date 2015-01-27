class ItemsController < ApplicationController
  before_action :authenticate_user!

  def new
    @item = Item.new
    @list = current_user.lists.find(params[:list_id])
  end

  def create
    @list = current_user.lists.find(params[:list_id])
    @item = Item.new(params.require(:item).permit(:name))
    @item.list_id = @list.id
    if @item.save
      redirect_to @list, :notice =>  "Your to-do was created."
    else
      render "new"
    end
  end

  def destroy
    @list = List.find(params[:list_id])
    @item = @list.items.find(params[:id])
    @item.destroy
    redirect_to list_items_path :notice => "Your task has been completed"
  end
end
