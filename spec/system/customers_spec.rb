require 'rails_helper'

describe '会員ログイン前のテスト' do
  describe 'ヘッダーのテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_link 'Motif', href: root_path
      end
      it 'Aboutリンクが表示される: 左上から２番目が「About」である' do
        about_link = find_all('a')[1].native.inner_text
        expect(about_link).to match(/About/i)
      end
      it 'Aboutリンクの内容が正しい' do
        about_link = find_all('a')[1].native.inner_text
        expect(page).to have_link about_link, href: about_path
      end
      it 'Teamsリンクが表示される: 左上から2番目が「Bands」である' do
        team_link = find_all('a')[2].native.inner_text
        expect(team_link).to match(/Bands/i)
      end
      it 'Teamsリンクの内容が正しい' do
       team_link = find_all('a')[2].native.inner_text
        expect(page).to have_link team_link, href: teams_path
      end
      it 'Activitiesリンクが表示される: 左上から3番目が「Activities」である' do
        activity_link = find_all('a')[3].native.inner_text
        expect(activity_link).to match(/Activities/i)
      end
      it 'Activitiesリンクの内容が正しい' do
        activity_link = find_all('a')[3].native.inner_text
        expect(page).to have_link activity_link, href: activities_path
      end
      it 'Signupリンクが表示される: 左上から4番目が「Signup」である' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(sign_up_link).to match(/Signup/i)
      end
      it 'Signupリンクの内容が正しい' do
        sign_up_link = find_all('a')[4].native.inner_text
        expect(page).to have_link sign_up_link, href: new_customer_registration_path
      end
      it 'Loginリンクが表示される: 左上から5番目が「Login」である' do
        log_in_link = find_all('a')[5].native.inner_text
        expect(log_in_link).to match(/Login/i)
      end
      it 'Loginリンクの内容が正しい' do
        log_in_link = find_all('a')[5].native.inner_text
        expect(page).to have_link log_in_link, href: new_customer_session_path
      end
    end
  end
end