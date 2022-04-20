require 'rails_helper'

RSpec.describe 'Customerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { customer.valid? }

    let!(:other_customer) { create(:customer) }
    let(:customer) { build(:customer) }

    context 'nameカラム' do
      it '空欄でないこと' do
        customer.name = ''
        is_expected.to eq false
      end
      it '2文字以上であること: 1文字はx' do
        customer.name = Faker::Lorem.characters(number: 1)
        is_expected.to eq false
      end
      it '2文字以上であること: 2文字は◯' do
        customer.name = Faker::Lorem.characters(number: 2)
        is_expected.to eq true
      end
      it '20文字以下であること: 20文字は◯' do
        customer.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end
      it '20文字以下であること: 21文字はx' do
        customer.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
      it '一意性があること' do
        customer.name = other_customer.name
        is_expected.to eq false
      end
    end

    context 'profileカラム' do
      it '50文字以下であること: 50文字は◯' do
        customer.profile = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end
      it '50文字以下であること: 51文字はx' do
        customer.profile = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Teamモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:teams).macro).to eq :has_many
      end
    end

    context 'Activityモデルとの関係' do
      it '1:Nとなっている' do
        expect(Customer.reflect_on_association(:activities).macro).to eq :has_many
      end
    end
  end
end