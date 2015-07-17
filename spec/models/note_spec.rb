require 'rails_helper'

RSpec.describe Note, type: :model do
  it { is_expected.to validate_presence_of(:message) }
  it { is_expected.to validate_presence_of(:details) }
  it { is_expected.to belong_to(:lead) }
end
