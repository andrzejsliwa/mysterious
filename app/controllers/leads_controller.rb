class LeadsController < ApplicationController
  load_and_authorize_resource

  def create
    render_validation(@lead) unless @lead.save
  end

  private

  def lead_params
    params.require(:lead).permit(:phone, :full_name)
  end
end
