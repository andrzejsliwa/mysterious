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

  describe 'POST /leads/:lead_id/notes.json' do
    let(:attributes) { attributes_for(:note).stringify_keys }
    subject { post "/leads/#{lead.id}/notes.json", {note: attributes}, @env}

    [:admin, :regular].each do |role|
      context "as #{role}" do

        before do
          login_as "andrzej.sliwa@i-tool.eu", role
        end

        context 'with valid attributes' do
          it 'responds with created lead' do
            subject
            expect(response.status).to eq(200)
            expect(json_response).to eq('note' => attributes.merge('id' => Note.last.id))
          end

          it 'creates a note owned by current user' do
            subject
            expect(response.status).to eq(200)
            expect(Note.with_role(role, current_user)).not_to be_nil
          end
        end

        context 'with missing message' do
          let(:attributes) { attributes_for(:note).except(:message).stringify_keys }
          it 'responds with validation errors' do
            subject
            expect(response.status).to eq(422)
            expect(json_response['errors'].keys).to eq(['message'])
          end
        end
      end
    end

    context "as GUEST" do
      it 'responds forbiden' do
        subject
        expect(response.status).to eq(403)
      end
    end
  end

  describe 'DELETE /leads/:lead_id/notes/:id.json' do
    let!(:note) { lead.notes.create(message: "message", details: "details") }
    subject { delete "/leads/#{lead.id}/notes/#{note.id}.json", {}, @env }

    context 'as ADMIN' do
      before { login_as "andrzej.sliwa@i-tool.eu", :admin }

      it 'responds with :no_content' do
        subject
        expect(response.status).to eq(204)
      end

      it 'destroys the note' do
        expect { subject }.to change { Note.all.size }.by(-1)
      end
    end

    context "as REGULAR" do
      before { login_as "andrzej.sliwa@i-tool.eu", :regular }
      context "as OWNER" do
        before { current_user.grant :regular, note }

        it 'destroys the note' do
          expect { subject }.to change { Note.count }.by(-1)
        end

        it 'responds with :no_content' do
          subject
          expect(response.status).to eq(204)
        end
      end

      context "as NOT OWNER" do
        it 'responds forbiden' do
          subject
          expect(response.status).to eq(403)
        end
      end
    end

    context "as GUEST" do
      before do
        login_as "andrzej.sliwa@i-tool.eu", :regular
      end

      it 'responds forbiden' do
        subject
        expect(response.status).to eq(403)
      end
    end
  end
end
