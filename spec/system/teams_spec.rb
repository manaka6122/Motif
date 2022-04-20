require 'rails_helper'

describe 'team_controllerのテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:team) { create(:team, customer: customer) }
  let!(:other_team) { create(:team, customer: other_customer) }
  
  describe '登録画面のテスト(ログイン済み)' do
    before do
      sign_in user
      visit new_team_path
    end
     context '表示の確認' do
       it 'URLが正しい' do
         expect(current_path).to eq '/teams/new'
       end
       it 'nameフォームが表示される' do
         expect(page).to have_field 'team[name]'
       end
       it 'nameフォームに値が入っていない' do
         expect(find_field('team[name]').text).to be_blank
       end
       it 'addressフォームが表示される' do
         expect(page).to have_field 'team[address]'
       end
       it 'addressフォームに値が入っていない' do
         expect(find_field('team[address]').text).to be_blank
       end
       it 'introductionフォームが表示される' do
         expect(page).to have_field 'team[introduction]'
       end
       it 'introductionフォームに値が入っていない' do
         expect(find_field('team[introduction]').text).to be_blank
       end
       it '登録ボタンが表示される' do
         expect(page).to have_button '登録'
       end
     end
     
     context '投稿成功のテスト' do
       before do
         fill_in 'team[name]', with: Faker::Lorem.characters(number: 10)
         fill_in 'team[address]', with: Faker::Lorem.characters(number: 10)
         fill_in 'team[introduction]', with: Faker::Lorem.characters(number: 20)
       end
       
       it '自分の新しい投稿が正しく保存される' do
         expect { click_button '登録' }.to change(customer.teams, :count).by(1)
       end
       it 'リダイレクト先が正しい' do
         expect(current_path).to eq '/teams/' + Team.last.id.to_s
       end
     end
  end
  
  describe '投稿一覧のテスト' do
    before do
      visit teams_path
    end
    
    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/teams'
      end
      it '新規登録画面へのリンクが存在する' do
        expect(page).to have_link '', href: new_team_path
      end
      it '自分の投稿と他人の投稿のtitleのリンク先がそれぞれ正しい' do
        expect(page).to have_link team.name, href: team_path(team)
        expect(page).to have_link other_team.name, href: team_path(other_team)
      end
      it '自分の投稿と他人の投稿のaddressが表示される' do
        expect(page).to have_content team.address
        expect(page).to have_content other_team.address
      end
      it '自分の投稿と他人の投稿のintroductionが表示される' do
        expect(page).to have_content team.introduction
        expect(page).to have_content other_team.introduction
      end
    end
  end
end