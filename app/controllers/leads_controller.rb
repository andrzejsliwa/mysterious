class LeadsController < ApplicationController
  load_and_authorize_resource

  def create
    render_validation(@lead) unless @lead.save
  end

  def destroy
    @lead.destroy
    render nothing: true, status: :no_content
  end
  
  private

  def lead_params
    params.require(:lead).permit(:phone, :full_name)
  end
end
