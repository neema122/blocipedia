class CollaboratorsController < ApplicationController
  
  before_action :set_wiki
  respond_to :html, :js
  
  def index
    @users = User.all
  end

  def create
    @collaborator = @wiki.collaborators.build(user_id: params[:user_id])
  

    if @collaborator.save
      flash[:notice] = "Collaborator was added."
    else
      flash[:error] = "There was an error saving your collaborator. Please try again."
    end

    respond_with(@collaborator) do |f|
      f.html { redirect_to wiki_collaborators_path(@wiki) }
    end
  end

    def destroy
    @collaborator = @wiki.collaborators.find(params[:id])
      
    if @collaborator.destroy
      flash[:notice] = "Item was removed."
    else
      flash[:error] = "Item couldn't be deleted. Try again."
    end

    respond_with(@collaborator) do |f|
      f.html { redirect_to wiki_collaborators_path(@wiki)  }
    end
  end

  private

  def set_wiki
    @wiki = Wiki.find(params[:wiki_id])
  end

end