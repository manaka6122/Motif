# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Admin.create!(
  email: ENV['ADMIN_EMAIL'],
  password: ENV['ADMIN_PASSWORD']
)

10.times do
  Customer.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    password: "password",
    password_confirmation: "password",
    profile: "よろしくお願いします。"
  )
end

  Team.create!(
    [
      {name: "ABC吹奏楽団", address: "大阪府大阪市", introduction: "初心者大歓迎!", customer_id: 1},
      {name: "ABCウィンドオーケストラ", address: "大阪府堺市", introduction: "お気軽にご連絡ください。", customer_id: 2},
      {name: "ABCウィンドアンサンブル", address: "兵庫県神戸市", introduction: "ブランクがある方でもお気軽にお問い合わせ下さい!", customer_id: 3},
      {name: "ABCシンフォニックバンド", address: "千葉県市川市", introduction: "演奏するのが大好きな人を当団では募集しています！", customer_id: 4},
      {name: "ABC吹奏楽クラブ", address: "広島県広島市", introduction: "ぜひ私たちと一緒に音楽しましょう！", customer_id: 5},
      {name: "AMC WINDS", address: "愛知県名古屋市", introduction: "幅色い年齢層の、幅広い職業のメンバーが時にはワイワイ、時には真剣に、楽しく音楽に没頭しています。", customer_id: 6}
    ]
  )

  Tag.create!(
    [
      {name: "パーカッション"},
      {name: "木管楽器"},
      {name: "金管楽器"},
      {name: "全パート"}
    ]
  )
  TeamTag.create!(
    [
      {team_id: 1, tag_id: 1},
      {team_id: 2, tag_id: 2},
      {team_id: 3, tag_id: 3},
      {team_id: 4, tag_id: 3},
      {team_id: 5, tag_id: 4},
      {team_id: 6, tag_id: 4}
    ]
  )

  Team.limit(6).zip(Customer.limit(6)) do |team, customer|
    Activity.create!(
      [
        {customer: customer,
        team: team,
        title: "第1回ABC定期演奏会",
        content: "お馴染みの曲からクラッシックまで演奏します。是非気軽にお越しください。",
        activity_on: "2022/05/15",
        status: 0,
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-activity1.jpg"), filename:"sample-activity1.jpg")},
        {customer: customer,
        team: team,
        title: "ABCクリスマスコンサート",
        content: "クリスマスソングを演奏します!",
        activity_on: "2022/12/20",
        status: 0,
        image: ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-activity2.jpg"), filename:"sample-activity2.jpg")}
      ]
    )
  end
