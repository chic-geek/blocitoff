class ListsController < ApplicationController

  # users must be signed in before any lists_controller method
  before_action :authenticate_user!

  def index
    @lists = current_user.lists
  end

  def show
    @list = current_user.lists.find(params[:id])
  end

  def new
    @list = List.new
  end

  def create
    @list = List.new(params.require(:list).permit(:title))
    @list.user_id = current_user.id # Set the user ID field to the current users ID.
    if @list.save
      redirect_to lists_path, :notice => "Your list was saved"
    else
      render "new"
    end
  end

  def edit
    @list = current_user.lists.find(params[:id])
  end

  def update
    @list = current_user.lists.find(params[:id])
    if @list.update_attributes(params.require(:list).permit(:title))
      redirect_to lists_path, :notice => "Your list has been updated."
    else
      render "edit"
    end
  end

  def destroy
    @list = current_user.lists.find(params[:id])
    @list.destroy
    redirect_to lists_path, :notice => "Your list has been deleted"
  end
end
