require 'rails_helper'

describe 'teamsのテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:team) { create(:team, customer: customer) }
  let!(:other_team) { create(:team, customer: other_customer) }

  before do
    visit new_customer_session_path
    fill_in 'customer[name]', with: customer.name
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe '登録画面のテスト(ログイン済み)' do
    before do
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
        click_button '登録'
        expect(current_path).to eq '/teams/' + Team.last.id.to_s
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '登録しました'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
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
      it '自分の投稿と他人の投稿のnameのリンク先がそれぞれ正しい' do
        expect(page).to have_link team.name, href: team_path(team)
        expect(page).to have_link other_team.name, href: team_path(other_team)
      end
      it '自分の投稿と他人の投稿のaddressが表示される' do
        expect(page).to have_content team.address
        expect(page).to have_content other_team.address
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit team_path(team)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/teams/' + team.id.to_s
      end
      it '投稿のnameが表示される' do
        expect(page).to have_content team.name
      end
      it '投稿のaddressが表示される' do
        expect(page).to have_content team.address
      end
      it '投稿のintroductionが表示される' do
        expect(page).to have_content team.introduction
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '編集', href: edit_team_path(team)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '削除', href: team_path(team)
      end
    end

    context 'サイドバーの確認' do
      it '自分の名前, メールアドレス, 紹介文が表示される' do
        expect(page).to have_content customer.name
        expect(page).to have_content customer.email
        expect(page).to have_content customer.profile
      end
      it '自分の会員情報編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_customer_path(customer)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '編集'
        expect(current_path).to eq '/teams/' + team.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '削除'
      end

      it '正しく削除される' do
        expect(Team.where(id: team.id).count).to eq 0
      end
      it 'リダイレクト先が投稿一覧画面になっている' do
        expect(current_path).to eq '/teams'
      end
    end

    describe '自分の投稿編集画面のテスト' do
      before do
        visit edit_team_path(team)
      end

      context '表示の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/teams/' + team.id.to_s + '/edit'
        end
        it '編集前のnameがフォームに表示される' do
          expect(page).to have_field 'team[name]', with: team.name
        end
        it '編集前のaddressがフォームに表示される' do
          expect(page).to have_field 'team[address]', with: team.address
        end
        it '編集前のintroductionがフォームに表示される' do
          expect(page).to have_field 'team[introduction]', with: team.introduction
        end
        it '更新ボタンが表示される' do
          expect(page).to have_button '更新'
        end
      end

      context '編集成功のテスト' do
        before do
          @team_old_name = team.name
          @team_old_address = team.address
          @team_old_introduction = team.introduction
          fill_in 'team[name]', with: Faker::Lorem.characters(number: 11)
          fill_in 'team[address]', with: Faker::Lorem.characters(number: 11)
          fill_in 'team[introduction]', with: Faker::Lorem.characters(number: 21)
          click_button '更新'
        end

        it 'nameが正しく更新される' do
          expect(team.reload.name).not_to eq @team_old_name
        end
        it 'addressが正しく更新される' do
          expect(team.reload.address).not_to eq @team_old_address
        end
        it 'introductionが正しく更新される' do
          expect(team.reload.introduction).not_to eq @team_old_introduction
        end
        it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
          expect(current_path).to eq '/teams/' + team.id.to_s
        end
        it 'サクセスメッセージが表示される' do
          expect(page).to have_content '更新が完了しました'
        end
      end
    end
  end
end