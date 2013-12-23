class RevisionsController < ApplicationController

  def index
    @revisions = Revision.all
  end

  def show
    @revision = Revision.find params[:id]
  end

  def create
    resource = params.require(:resource)
    events = params.require(:events)

    @revision = Revision.new \
      resource_type_name: resource[:type],
      resource_uuid: resource[:uuid],
      resource_version: resource[:version]

    events.each do |e|
      event = Event.new \
        type_name: e[:type],
        occurred_at: e[:occurredAt],
        payload: e[:payload]
      @revision.events << event
    end

    if @revision.save
      render "created", status: :created, location: revision_url(@revision)
    else
      render "invalid", status: :unprocessable_entity
    end

  rescue ActiveRecord::RecordNotUnique
    @conflict = Revision.find_by \
      resource_type_name: @revision.resource_type_name,
      resource_uuid: @revision.resource_uuid,
      resource_version: @revision.resource_version

    render "conflict", status: :conflict
  end

end
