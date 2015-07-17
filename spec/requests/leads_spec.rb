require 'rails_helper'

RSpec.describe 'leads', type: :request do
  include AuthenticationHelper

  describe 'GET /leads.json' do
    subject { get '/leads.json', {}, @env }

    [:admin, :guest, :regular].each do |role|
      context "as #{role.upcase}" do
        before do
          login_as "andrzej.sliwa@i-tool.eu", role
          create(:lead)
        end

        it 'returns list of leads' do
          subject
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'GET /leads/:id.json' do
    subject { get "/leads/#{lead.id}.json", {}, @env }

    [:admin, :guest, :regular].each do |role|
      context "as #{role.upcase}" do
        let(:lead) { create(:lead) }
        before { login_as "andrzej.sliwa@i-tool.eu", role }

        it 'returns lead' do
          subject
          expect(response.status).to eq(200)
          expect(json_response).to eq({'lead' => {'id' => lead.id,
                                                  'phone' => lead.phone,
                                                  'full_name' => lead.full_name}})
        end
      end
    end

    describe "missing data" do
      let(:lead) { double(id: 0) }
      it 'responds not_found' do
        subject
        expect(response.status).to eq(404)
      end
    end
  end

  describe 'POST /leads.json' do
    let(:attributes) { attributes_for(:lead).stringify_keys }
    subject { post '/leads.json', {lead: attributes}, @env}

    context "as ADMIN" do
      let(:role) { :admin }

      before do
        login_as "andrzej.sliwa@i-tool.eu", role
      end

      context 'with valid attributes' do
        it 'responds with created lead' do
          subject
          expect(response.status).to eq(200)
          expect(json_response).to eq('lead' => attributes.merge('id' => Lead.last.id))
        end

        it 'creates a lead owned by current user' do
          subject
          expect(response.status).to eq(200)
          expect(Lead.with_role(role, current_user)).not_to be_nil
        end
      end

      context 'with missing phone' do
        let(:attributes) { attributes_for(:lead).except(:phone).stringify_keys }
        it 'responds with validation errors' do
          subject
          expect(response.status).to eq(422)
          expect(json_response['errors'].keys).to eq(['phone'])
        end
      end
    end

    [:regular, :guest].each do |role|
      context "as #{role.upcase}" do
        before do
          login_as "andrzej.sliwa@i-tool.eu", role
        end

        it 'responds forbiden' do
          subject
          expect(response.status).to eq(403)
        end
      end
    end
  end

  describe 'DELETE /leads/:id.json' do
    let!(:lead) { create(:lead) }
    subject { delete "/leads/#{lead.id}.json", {}, @env }

    context 'as ADMIN' do
      before { login_as "andrzej.sliwa@i-tool.eu", :admin }

      it 'destroys the lead' do
        expect { subject }.to change { Lead.count }.by(-1)
      end

      it 'responds with :no_content' do
        subject
        expect(response.status).to eq(204)
      end
    end

    [:regular, :guest].each do |role|
      context "as #{role}" do
        before do
          login_as "andrzej.sliwa@i-tool.eu", role
        end

        it 'responds forbiden' do
          subject
          expect(response.status).to eq(403)
        end
      end
    end
  end
end
