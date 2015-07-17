require 'rails_helper'

RSpec.describe Lead, type: :model do
  it { is_expected.to validate_presence_of(:phone) }
  it { is_expected.to validate_presence_of(:full_name) }
  it { is_expected.to have_many(:notes) }
end
