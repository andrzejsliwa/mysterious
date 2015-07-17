class NotesController < ApplicationController
  load_and_authorize_resource :lead
  load_and_authorize_resource through: :lead

end
