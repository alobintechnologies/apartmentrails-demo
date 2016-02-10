class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :email, presence: true

  def has_payment_info?
    braintree_customer_id
  end
end
