require 'rails_helper'

RSpec.describe 'Activityモデルのテスト', model: :model do
  describe 'バリデーションのテスト' do
    subject { activity.valid? }
    let(:customer) { create(:customer) }
    let(:team) { create(:team, customer_id: customer.id) }
    let!(:activity) { build(:activity, customer_id: customer.id, team_id: team.id) }

    context 'titleカラム' do
      it '空欄でないこと' do
        activity.title = ''
        is_expected.to eq false
      end
    end

    context 'contentカラム' do
      it '空欄でないこと' do
        activity.content = ''
        is_expected.to eq false
      end
      it '200文字以下であること: 200文字は◯' do
        activity.content = Faker::Lorem.characters(number: 200)
        is_expected.to eq true
      end
      it '200文字以下であること: 201文字はx' do
        activity.content = Faker::Lorem.characters(number: 201)
        is_expected.to eq false
      end
    end

    context 'activity_onカラム' do
      it '空欄でないこと' do
        activity.activity_on = ''
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Customerモデルとの関係' do
      it 'N:1となっている' do
        expect(Activity.reflect_on_association(:customer).macro).to eq :belongs_to
      end
    end

    context 'Teamモデルとの関係' do
      it 'N:1となっている' do
        expect(Activity.reflect_on_association(:team).macro).to eq :belongs_to
      end
    end
  end
end