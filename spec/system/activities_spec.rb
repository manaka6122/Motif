require 'rails_helper'

describe 'activitiesのテスト' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:team){ create(:team, customer: customer) }
  let!(:other_team){ create(:team, customer: other_customer) }
  let!(:activity) { create(:activity, customer: customer, team: team) }
  let!(:other_activity) { create(:activity, customer: other_customer, team: other_team) }

  before do
    visit new_customer_session_path
    fill_in 'customer[name]', with: customer.name
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe '投稿画面のテスト(ログイン済み)' do
    before do
      visit new_activity_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/activities/new'
      end
      it 'imageフォームが表示される' do
        expect(page).to have_field 'activity[image]'
      end
      it 'team.nameフォームが表示される' do
        expect(page).to have_field 'activity[team_id]'
      end
      it 'titleフォームが表示される' do
        expect(page).to have_field 'activity[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('activity[title]').text).to be_blank
      end
      it 'contentフォームが表示される' do
        expect(page).to have_field 'activity[content]'
      end
      it 'contentフォームに値が入っていない' do
        expect(find_field('activity[content]').text).to be_blank
      end
      it 'activity_onフォームが表示される' do
        expect(page).to have_field 'activity[activity_on]'
      end
      it 'activity_onフォームに値が入っていない' do
        expect(find_field('activity[activity_on]').text).to be_blank
      end
      it 'statusラジオボタンが表示される' do
        expect(page).to have_field 'activity[status]'
      end
      it '投稿ボタンが表示される' do
        expect(page).to have_button '投稿'
      end
    end

    context '投稿成功のテスト' do
      before do
        select team.name, from: 'activity[team_id]'
        fill_in 'activity[title]', with: Faker::Lorem.characters(number: 10)
        fill_in 'activity[content]', with: Faker::Lorem.characters(number: 20)
        fill_in 'activity[activity_on]', with:  Faker::Date.between(from: 2.days.ago, to: Date.today)
        choose '公開'
      end

      it '自分の新しい投稿が正しく保存される' do
        expect { click_button '投稿' }.to change(customer.activities, :count).by(1)
      end
      it 'リダイレクト先が正しい' do
        click_button '投稿'
        expect(current_path).to eq '/activities/' + Activity.last.id.to_s
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '投稿しました'
      end
    end
    describe '投稿一覧画面のテスト' do
      before do
        visit activities_path
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/activities'
        end
        it '新規登録画面へのリンクが存在する' do
          expect(page).to have_link '', href: new_activity_path
        end
        it '自分の投稿と他人の投稿のtitleのリンク先がそれぞれ正しい' do
          expect(page).to have_link activity.title, href: activity_path(activity)
          expect(page).to have_link other_activity.title, href: activity_path(other_activity)
        end
        it '自分の投稿と他人の投稿のteam.nameが表示される' do
          expect(page).to have_content activity.team.name
          expect(page).to have_content other_activity.team.name
        end
        it '自分の投稿と他人の投稿のcontentが表示される' do
          expect(page).to have_content activity.content
          expect(page).to have_content other_activity.content
        end
      end
    end

     describe '自分の投稿詳細画面のテスト' do
      before do
        visit activity_path(activity)
      end

      context '表示内容の確認' do
        it 'URLが正しい' do
          expect(current_path).to eq '/activities/' + activity.id.to_s
        end
        it '投稿のteam.nameが表示される' do
          expect(page).to have_content activity.team.name
        end
        it '投稿のtitleが表示される' do
          expect(page).to have_content activity.title
        end
        it '投稿のcontentが表示される' do
          expect(page).to have_content activity.content
        end
        it '投稿のactivity_onが表示される' do
          expect(page).to have_content activity.activity_on
        end
        it '投稿の編集リンクが表示される' do
          expect(page).to have_link '編集', href: edit_activity_path(activity)
        end
        it '投稿の削除リンクが表示される' do
          expect(page).to have_link '削除', href: activity_path(activity)
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
          expect(current_path).to eq '/activities/' + activity.id.to_s + '/edit'
        end
      end

      context '削除リンクのテスト' do
        before do
          click_link '削除'
        end

        it '正しく削除される' do
          expect(Activity.where(id: activity.id).count).to eq 0
        end
        it 'リダイレクト先が投稿一覧画面になっている' do
          expect(current_path).to eq '/activities'
        end
      end

      describe '自分の投稿編集画面のテスト' do
        before do
          visit edit_activity_path(activity)
        end

        context '表示の確認' do
          it 'URLが正しい' do
            expect(current_path).to eq '/activities/' + activity.id.to_s + '/edit'
          end
          it '画像編集フォームが表示される' do
            expect(page).to have_field 'activity[image]'
          end
          it '編集前のteam.nameがフォームに表示されている' do
            expect(page).to have_select('activity[team_id]', selected: activity.team.name)
          end
          it '編集前のtitleがフォームに表示されている' do
            expect(page).to have_field 'activity[title]', with: activity.title
          end
          it '編集前のcontentがフォームに表示されている' do
            expect(page).to have_field 'activity[content]', with: activity.content
          end
          it '編集前のactivity_onがフォームに表示されている' do
            expect(page).to have_field 'activity[activity_on]', with: activity.activity_on
          end
          it '編集前のstatusがフォームに表示されている' do
            expect(page).to have_field 'activity[status]', with: activity.status
          end
          it '更新ボタンが表示される' do
            expect(page).to have_button '更新'
          end
        end

        context '編集成功のテスト' do
          before do
            @activity_old_title = activity.title
            @activity_old_content = activity.content
            @activity_old_activity_on = activity.activity_on
            @activity_old_status = activity.status
            select team.name, from: 'activity[team_id]'
            fill_in 'activity[title]', with: Faker::Lorem.characters(number: 11)
            fill_in 'activity[content]', with: Faker::Lorem.characters(number: 21)
            fill_in 'activity[activity_on]', with: Faker::Date.between(from: 5.days.ago, to: Date.today)
            choose '非公開'
            click_button '更新'
          end

          it 'titleが正しく更新される' do
            expect(activity.reload.title).not_to eq @activity_old_title
          end
          it 'contentが正しく更新される' do
            expect(activity.reload.content).not_to eq @activity_old_content
          end
          it 'activity_onが正しく更新される' do
            expect(activity.reload.activity_on).not_to eq @activity_old_activity_on
          end
          it 'statusが正しく更新される' do
            expect(activity.reload.status).not_to eq @activity_old_status
          end
          it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
            expect(current_path).to eq '/activities/' + activity.id.to_s
          end
          it 'サクセスメッセージが表示される' do
            expect(page).to have_content '更新が完了しました'
          end
        end
      end
    end
  end
end