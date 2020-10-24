# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  status     :integer
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :article do
    sequence(:body) {|n| "#{n}_#{Faker::Quote.famous_last_words}" }
    sequence(:title) {|n| "#{n}_#{Faker::Job.title}" }

    # statusのランダム入力
    array_status = ["open", "draft"]
    status { array_status.sample }

    user
  end
end
