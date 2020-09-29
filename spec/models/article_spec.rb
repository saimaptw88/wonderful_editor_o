# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
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
require "rails_helper"

RSpec.describe Article, type: :model do
  # title
  context "タイトルが入力されている時" do
    it "記事が作成される" do
      user = FactoryBot.create(:user)
      # article = FactoryBot.create(:article, users_with_groups)
      article = user.articles.new(title: Faker::Quote.famous_last_words, body: Faker::Job.title)
      expect(article).to be_valid
    end
  end

  context "タイトルが入力されていない時" do
    it "記事は作成されない" do
      user = FactoryBot.create(:user)
      article = user.articles.new(body: "bbb")
      expect(article).to be_invalid
      # expect(article.errors.details[:title][0][:error]).to eq :blank
      # expect(article.errors.messages[:title][0]).to eq "can't be blank"
    end
  end
end
