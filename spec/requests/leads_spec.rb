require 'rails_helper'

RSpec.describe 'leads', type: :request do
  describe 'GET /leads.json' do
    subject { get '/leads.json', {}, @env }

    [:admin, :guest, :regular].each do |role|
      context "as #{role.upcase}" do
        before { create(:lead) }

        it 'returns list of leads' do
          subject
          expect(response.status).to eq(200)
        end
      end
    end
  end	
end