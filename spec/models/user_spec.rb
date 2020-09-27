# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  image                  :string
#  name                   :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider      (uid,provider) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  # email
  # emailが入力されていない時
  context "email is not entered" do
    it "account is not create" do
      user = FactoryBot.build(:user, email: "")
      expect(user).to be_invalid
      # expect(user.errors.details[:email][0][:error]).to eq :blank
    end
  end

  # emailが入力されている時
  context "if same email is aleady exist" do
    it "account is not create" do
      a = FactoryBot.create(:user)
      user = FactoryBot.build(:user, email: a.email.to_s)
      expect(user).to be_invalid
    end
  end

  context "同じemailが存在しない時" do
    it "アカウントが作成される" do
      user = FactoryBot.create(:user)
      expect(user).to be_valid
    end
  end

  # password
  # passwordが入力されていない時
  context "passwordが存在しない時" do
    it "アカウントが作成されない" do
      user = FactoryBot.build(:user, password: "")
      expect(user).to be_invalid
    end
  end

  # passwordが入力されている時
  # context "同じemailが存在しない時"と同じため削除
  # context "passwordが存在する時" do
  #   it "アカウントが作成される" do
  #     user = FactoryBot.build(:user)
  #     expect(user).to be_valid
  #   end
  # end

  # name
  # nameが入力されていない時
  context "nameが入力されていない時" do
    it "アカウントが作成されない" do
      user = FactoryBot.build(:user, name: "")
      expect(user).to be_invalid
    end
  end

  # nameが入力されている時
  context "nameが入力されている時" do
    it "アカウントが作成される" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end
  end
end
