require 'rails_helper'

RSpec.describe 'Notes', type: :request do
  include AuthenticationHelper

  let(:lead) { create(:lead) }

  describe 'GET /leads/:lead_id/notes.json' do
    subject { get "/leads/#{lead.id}/notes.json", {}, @env }

    [:admin, :guest, :regular].each do |role|
      context "as #{role.upcase}" do
        before do
          login_as "andrzej.sliwa@i-tool.eu", role
          lead.notes.create(message: "message", details: "details")
        end

        it 'returns list of notes' do
          subject
          expect(response.status).to eq(200)
          expect(json_response["notes"]).not_to be_empty
        end
      end
    end
  end

  describe 'GET /leads/:lead_id/notes/:id.json' do
    subject { get "/leads/#{lead.id}/notes/#{note.id}.json", {}, @env }

    [:admin, :guest, :regular].each do |role|
      context "as #{role.upcase}" do
        let(:note) { lead.notes.create(message: "message", details: "details") }

        it 'returns note' do
          subject
          expect(response.status).to eq(200)
          expect(json_response).to eq({'note' => {'id' => note.id,
                                                  'details' => note.details,
                                                  'message' => note.message}})
        end
      end
    end

    describe "missing data" do
      let(:note) { double(id: 0) }
      it 'responds not_found' do
        subject
        expect(response.status).to eq(404)
      end
    end
  end
end
