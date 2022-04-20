require 'rails_helper'

RSpec.describe 'Teamモデルのテスト', model: :model do
  describe 'バリデーションのテスト' do
    subject { team.valid? }

    let(:customer) { create(:customer) }
    let!(:team) { build(:team, customer_id: customer.id) }

    context 'nameカラム' do
      it '空欄でないこと' do
        team.name = ''
        is_expected.to eq false
      end
    end

    context 'addressカラム' do
      it '空欄でないこと' do
        team.address = ''
        is_expected.to eq false
      end
    end

    context 'introductionカラム' do
      it '空欄でないこと' do
        team.introduction = ''
        is_expected.to eq false
      end
      it '200文字以下であること: 200文字は◯' do
        team.introduction = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字はx' do
        team.introduction = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Customerモデルとの関係' do
      it 'N:1となっている' do
        
        expect(Team.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end

    context 'Activityモデルとの関係' do
      it '1:Nとなっている' do
        expect(Team.reflect_on_association(:activities).macro).to eq :has_many
      end
    end
  end
end