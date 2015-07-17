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
end