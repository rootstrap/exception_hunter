require 'rails_helper'
require 'byebug'
module ExceptionHunter
  RSpec.describe ExceptionHunter::Error, type: :model do
    subject { build(:exception_hunter_error) }

    describe 'validations' do
      it { is_expected.to validate_presence_of(:name) }
      it { is_expected.to validate_presence_of(:ocurred_at) }
      it { is_expected.to validate_uniqueness_of(:name).ignoring_case_sensitivity }
    end
  end
end
