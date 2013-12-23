class RevisionsController < ApplicationController

  def index
    @revisions = Revision.all
  end

  def show
    @revision = Revision.find params[:id]
  end

  def create
    revision_params = params.require(:revision)

    @revision = Revision.new \
      resource_type: revision_params[:resourceType],
      resource_uuid: revision_params[:resourceUUID],
      resource_version: revision_params[:resourceVersion]

    revision_params[:events].each do |event_params|
      event = Event.new \
        type_name: event_params[:type],
        occurred_at: event_params[:occurredAt],
        payload: event_params[:payload]
      @revision.events << event
    end

    if @revision.save
      render "created", status: :created, location: revision_url(@revision)
    else
      render "invalid", status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    @conflict = Revision.find_by \
      resource_type: @revision.resource_type,
      resource_uuid: @revision.resource_uuid,
      resource_version: @revision.resource_version

    render "conflict", status: :conflict
  end

end
