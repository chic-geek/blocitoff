class ListsController < ApplicationController

  # users must be signed in before any lists_controller method
  before_action :authenticate_user!

  def index
    @list = current_user.list
  end

  def new
  end

  def edit
  end
end
