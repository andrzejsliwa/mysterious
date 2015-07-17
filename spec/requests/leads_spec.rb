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
end