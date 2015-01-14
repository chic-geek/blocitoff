class ListsController < ApplicationController

  # users must be signed in before any lists_controller method
  before_action :authenticate_user!

  def index
  end

  def show
    @list = current_user.list
  end

  def new
  end

  def edit
  end
end
