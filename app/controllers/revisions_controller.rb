class RevisionsController < ApplicationController

  def index
    @revisions = Revision.all
  end

  def show
    @revision = Revision.find params[:id]
  end

  def create
    @revision = Revision.json_new params.require(:revision)

    if @revision.save
      render "created", status: :created, location: revision_url(@revision)
    else
      render "invalid", status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    @conflict = Revision.find_conflicting @revision
    render "conflict", status: :conflict
  end

end
