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
require "rails_helper"

RSpec.describe Article, type: :model do
  # title
  context "タイトルが入力されている時" do
    it "記事が作成される" do
      user = FactoryBot.create(:user)
      # article = user.articles.new(title: Faker::Quote.famous_last_words, body: Faker::Job.title)
      article = FactoryBot.create(:article, user_id: user.id)
      expect(article).to be_valid
    end
  end

  context "タイトルが入力されていない時" do
    it "記事は作成されない" do
      user = FactoryBot.create(:user)
      article = user.articles.new(body: "fff", title: nil)
      # article = FactoryBot.build(:article, title:"", user_id: user.id)
      expect(article).to be_invalid
      # expect(article.errors.details[:title][0][:error]).to eq :blank
      # expect(article.errors.messages[:title][0]).to eq "can't be blank"
    end
  end

  context "status: が入力されている" do
    it "status: :openの時記事が作成される" do
      article = create(:article, status: :open)
      expect(article).to be_valid
    end

    it "status: :openの入力で記事作成に成功し、作成された記事がstatus: :openである" do
      article = create(:article, status: :open)
      expect(article.status).to eq "open"
    end

    it "status: :draftの時記事が作成される" do
      article = create(:article, status: :draft)
      expect(article).to be_valid
    end

    it "status: :draftの入力で記事作成に成功し、作成された記事がstatus: :draftである" do
      article = create(:article, status: :draft)
      expect(article.status).to eq "draft"
    end
  end
end
