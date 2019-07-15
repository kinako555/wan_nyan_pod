require 'rails_helper'
include SpecTestHelper

RSpec.describe User, type: :model do
    let(:user) { create(:user).activate! }
end

describe User do 
    it "有効なファクトリを持つこと" do 
      expect(user).to be_valid
    end
end