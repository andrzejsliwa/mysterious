class NotesController < ApplicationController
  load_and_authorize_resource :lead
  load_and_authorize_resource through: :lead

  def create
    render_validation(@note) unless @note.save
  end

  private

  def note_params
    params.require(:note).permit(:message, :details)
  end
end
