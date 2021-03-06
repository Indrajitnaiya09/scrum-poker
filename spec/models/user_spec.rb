require 'rails_helper'

describe User, type: [:models, :task] do
  let(:user) { create :user, name: name }
  let(:name) { "Valter" }
  context 'When all params are valid' do
    it 'Would create new user' do
      expect { 
        user 
      }.to change(User, :count).by(1)
    end
  end
  context 'When is pass a invalid params' do
    context 'When try create a user with utilized name' do
     before do
       user
     end
     it 'Should not create a new user' do
       expect {
         User.create()
       }.to change(User, :count).by(0)
     end
    end
  end
end
