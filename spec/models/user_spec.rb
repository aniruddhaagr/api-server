# frozen_string_literal: true
require "rails_helper"

RSpec.describe User, type: :model do

  it { should have_many(:tokens) }

  it 'should not save user without without attributes' do
    user = User.new
    expect { user.save }.to_not change(User, :count)
  end

  it 'should save user with all details' do
    user = User.new({ first_name: 'First', last_name: 'last', email: 'test@example.com', password: '123456' })
    expect { user.save }.to change(User, :count).by(1)
  end

  it 'should not save user without without first name' do
    user = User.new({ last_name: 'last', email: 'test@example.com', password: '123456' })
    expect { user.save }.to_not change(User, :count)
  end

  it 'should not save user without without last name' do
    user = User.new({ first_name: 'First', email: 'test@example.com', password: '123456' })
    expect { user.save }.to_not change(User, :count)
  end

  it 'should not save user without without email' do
    user = User.new({ first_name: 'First', last_name: 'last', password: '123456' })
    expect { user.save }.to_not change(User, :count)
  end

  it 'should not save user without without password' do
    user = User.new({ first_name: 'First', last_name: 'last', email: 'test@example.com' })
    expect { user.save }.to_not change(User, :count)
  end
end
