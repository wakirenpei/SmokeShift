class User < ApplicationRecord
  authenticates_with_sorcery!

  enum smoking_status: { smoker: 0, non_smoker: 1 }

  validates :password, length: { minimum: 8 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }

  validates :name, presence: true, length: { maximum: 10 }
  validates :email, presence: true, uniqueness: true
end
