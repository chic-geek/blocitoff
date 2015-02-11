class ItemsController < ApplicationController
  before_action :authenticate_user!
  respond_to :html, :js

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
    @list = current_user.lists.find(params[:list_id])
    @item = @list.items.find(params[:id])

    if @item.destroy
      flash.now[:notice] = "Your task has been marked as complete"
    else
      flash.now[:error] = "There seemed to be an error, please try again"
    end

    respond_with(@item) do |format|
      format.html { redirect_to [@list] }
      # format.js { render :destroy } this is the default behaviour.
    end
  end
end
