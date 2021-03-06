require 'rails_helper'

describe 'customersのテスト:ログイン前' do
  let(:customer) { create(:customer) }
  let!(:team) { create(:team, customer: customer) }
  let!(:activity) { create(:activity, customer: customer, team: team) }

  describe 'ヘッダーのテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_link 'Motif', href: root_path
      end
      it 'Aboutリンクが表示される: 左上から1番目が「About」である' do
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

  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Loginボタンが表示される' do
        expect(page).to have_link 'Login', href: new_customer_session_path
      end
      it 'Signupボタンが表示される' do
        expect(page).to have_link 'Signup', href: new_customer_registration_path
      end
      it 'Guest loginボタンが表示される' do
        expect(page).to have_link 'Guest login', href: customers_guest_sign_in_path
      end
    end
  end

  describe 'About画面のテスト' do
    before do
      visit about_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/about'
      end
    end
  end

  describe '会員新規登録のテスト' do
    before do
      visit new_customer_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'customer[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'profileフォームが表示される' do
        expect(page).to have_field 'customer[profile]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'customer[password_confirmation]'
      end
      it '新規登録ボタンが表示される' do
        expect(page).to have_button '新規登録'
      end
    end
    
    context '新規登録成功のテスト'do
      before do
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 5)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[profile]', with: Faker::Lorem.characters(number: 10)
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end
      
      it '正しく新規登録されている' do
        expect { click_button '新規登録' }.to change(Customer.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、新規登録できた会員の詳細画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/customers/' + Customer.last.id.to_s
      end
      it 'サクセスメッセージが表示されている' do
        click_button '新規登録'
        expect(page).to have_content '登録が完了しました'
      end
    end
    
    context '新規登録失敗のテスト: nameを1文字にする' do
      before do
        @name = Faker::Lorem.characters(number: 1)
        @email = Faker::Internet.email
        @profile = Faker::Lorem.characters(number: 10)
        fill_in 'customer[name]', with: @name
        fill_in 'customer[email]', with: @email
        fill_in 'customer[profile]', with: @profile
        fill_in 'customer[password]', with: 'password'
        fill_in 'customer[password_confirmation]', with: 'password'
      end
      
      it '新規登録されない' do
        expect { click_button '新規登録' }.not_to change(Customer.all, :count)
      end
      it '新規登録画面を表示しており、フォームの内容が正しい' do
        click_button '新規登録'
        expect(page).to have_content '新規登録'
        expect(page).to have_field 'customer[name]', with: @name
        expect(page).to have_field 'customer[email]', with: @email
        expect(page).to have_field 'customer[profile]', with: @profile
      end
      it 'バリデーションエラーが表示される' do
        click_button '新規登録'
        expect(page).to have_content '名前は2文字以上に設定して下さい。'
      end
    end
  end

  describe '会員ログインのテスト' do
    let(:customer) { create(:customer) }

    before do
      visit new_customer_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'customer[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'customer[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'customer[password]'
      end
      it 'ログインボタンが表示される' do
        expect(page).to have_button 'ログイン'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'customer[name]', with: customer.name
        fill_in 'customer[email]', with: customer.email
        fill_in 'customer[password]', with: customer.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先が、ログインした会員の詳細画面になっている' do
        expect(current_path).to eq '/customers/' + customer.id.to_s
      end
      it 'サクセスメッセージが表示されている' do
        expect(page).to have_content 'ログインしました'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'customer[name]', with: ''
        fill_in 'customer[email]', with: ''
        fill_in 'customer[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/customers/sign_in'
      end
      it 'アラートメッセージが表示される' do
        expect(page).to have_content '不正です'
      end
    end
  end

  describe 'ログインしていない場合のアクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it '会員編集画面' do
      visit edit_customer_path(customer)
      is_expected.to eq '/customers/sign_in'
      expect(page).to have_content 'ログインしてください'
    end
    it 'team投稿編集画面' do
      visit edit_team_path(team)
      is_expected.to eq '/customers/sign_in'
      expect(page).to have_content 'ログインしてください'
    end
    it 'activity投稿編集画面' do
      visit edit_activity_path(activity)
      is_expected.to eq '/customers/sign_in'
      expect(page).to have_content 'ログインしてください'
    end
  end
end

describe 'customersのテスト:ログイン後' do
  let(:customer) { create(:customer) }
  let!(:other_customer) { create(:customer) }
  let!(:team) { create(:team, customer: customer) }
  let!(:other_team) { create(:team, customer: other_customer) }
  let!(:activity) { create(:activity, customer: customer, team: team) }
  let!(:other_activity) { create(:activity, customer: other_customer, team: other_team) }

  before do
    visit new_customer_session_path
    fill_in 'customer[name]', with: customer.name
    fill_in 'customer[email]', with: customer.email
    fill_in 'customer[password]', with: customer.password
    click_button 'ログイン'
  end

  describe 'ヘッダーのテスト' do
    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_link 'Motif', href: root_path
      end
      it 'Mypageリンクが表示される: 左上から1番目が「Mypage」である' do
        mypage_link = find_all('a')[1].native.inner_text
        expect(mypage_link).to match(/Mypage/i)
      end
      it 'Messageリンクが表示される: 左上から2番目が「Message」である' do
        message_link = find_all('a')[2].native.inner_text
        expect(message_link).to match(/Message/i)
      end
      it 'Teamsリンクが表示される: 左上から3番目が「Bands」である' do
        team_link = find_all('a')[3].native.inner_text
        expect(team_link).to match(/Bands/i)
      end
      it 'Activitiesリンクが表示される: 左上から4番目が「Activities」である' do
        activity_link = find_all('a')[4].native.inner_text
        expect(activity_link).to match(/Activities/i)
      end
      it 'Logoutリンクが表示される: 左上から5番目が「Logout」である' do
        logout_link = find_all('a')[5].native.inner_text
        expect(logout_link).to match(/Logout/i)
      end
    end
  end

  describe '会員ログアウトのテスト' do
    before do
      click_link 'Logout'
    end

    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている: ログアウト後のリダイレクト先においてAbout画面へのリンクが存在する' do
        expect(page).to have_link '', href: '/about'
      end
      it 'ログアウト後のリダイレクト先が、トップ画面になっている' do
        expect(current_path).to eq '/'
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '会員詳細画面のテスト' do
    before do
      visit customer_path(customer)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/' + customer.id.to_s
      end
      it '自分の名前, メールアドレス, 紹介文が表示される' do
        expect(page).to have_content customer.name
        expect(page).to have_content customer.email
        expect(page).to have_content customer.profile
      end
      it '自分の会員情報編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_customer_path(customer)
      end
      it '自分が投稿したTeam一覧が表示される' do
        expect(page).to have_link team.name, href: team_path(team)
        expect(page).to have_content team.address
      end
      it '自分が投稿したActivity一覧が表示される' do
        expect(page).to have_link activity.title, href: activity_path(activity)
        expect(page).to have_content activity.content
        expect(page).to have_content activity.team.name
      end
    end
  end

  describe '他人の会員詳細画面のテスト' do
    before do
      visit customer_path(other_customer)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/' + other_customer.id.to_s
      end
      it '他人の名前と紹介文が表示される' do
        expect(page).to have_content other_customer.name
        expect(page).to have_content other_customer.profile
      end
      it '他人のメールアドレスは表示されない' do
        expect(page).not_to have_content other_customer.email
      end
      it '他人の会員情報編集画面へのリンクは存在しない' do
        expect(page).not_to have_link '', href: edit_customer_path(customer)
      end
      it '他人が投稿したTeam一覧が表示される' do
        expect(page).to have_link other_team.name, href: team_path(other_team)
        expect(page).to have_content other_team.address
      end
      it '自分が投稿したActivity一覧が表示される' do
        expect(page).to have_link other_activity.title, href: activity_path(other_activity)
        expect(page).to have_content other_activity.content
        expect(page).to have_content other_activity.team.name
      end
    end
  end

  describe '会員情報編集画面のテスト' do
    before do
      visit edit_customer_path(customer)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/customers/' + customer.id.to_s + '/edit'
      end
      it '画像編集フォームが表示されている' do
        expect(page).to have_field 'customer[profile_image]'
      end
      it '編集前のnameがフォームに表示されている' do
        expect(page).to have_field 'customer[name]', with: customer.name
      end
      it '編集前のemailがフォームに表示されている' do
        expect(page).to have_field 'customer[email]', with: customer.email
      end
      it '編集前のprofileがフォームに表示されている' do
        expect(page).to have_field 'customer[profile]', with: customer.profile
      end
      it '保存ボタンが表示される' do
        expect(page).to have_button '保存'
      end
    end

    context '編集成功のテスト' do
      before do
        @customer_old_name = customer.name
        @customer_old_email = customer.email
        @customer_old_profile = customer.profile
        fill_in 'customer[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'customer[email]', with: Faker::Internet.email
        fill_in 'customer[profile]', with: Faker::Lorem.characters(number: 21)
        click_button '保存'
      end

      it 'nameが正しく更新される' do
        expect(customer.reload.name).not_to eq @customer_old_name
      end
      it 'emailが正しく更新される' do
        expect(customer.reload.email).not_to eq @customer_old_email
      end
      it 'profileが正しく更新される' do
        expect(customer.reload.profile).not_to eq @customer_old_profile
      end
      it 'リダイレクト先が、自分の会員詳細画面になっている' do
        expect(current_path).to eq '/customers/' + customer.id.to_s
      end
      it 'サクセスメッセージが表示される' do
        expect(page).to have_content '更新が完了しました'
      end
    end
    
    context '編集失敗のテスト: nameを1文字にする' do
      before do
        @name = Faker::Lorem.characters(number: 1)
        fill_in 'customer[name]', with: @name
        click_button '保存'
      end
      
      it '更新されない' do
        expect(customer.reload.name).to eq customer.name
      end
      it '会員編集画面を表示しており、フォームの内容が正しい' do
        expect(page).to have_field 'customer[name]', with: @name
      end
      it 'バリデーションエラーが表示される' do
        expect(page).to have_content '名前は2文字以上に設定して下さい。'
      end
    end
  end
end