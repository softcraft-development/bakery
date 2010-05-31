class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # , :lockable and :timeoutable
  devise :database_authenticatable, 
    :registerable, 
    :token_authenticatable,
    # :confirmable,
    :recoverable, 
    :rememberable, 
    :trackable, 
    :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
end
