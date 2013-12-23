class RevisionsController < ApplicationController

  def index
    @revisions = Revision.all
  end

end
