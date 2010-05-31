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
  attr_protected :role_list
  before_save :set_role_list!
  
  def roles=(roles)
    @role_set = Array(roles)
  end

  def roles
    @role_set ||= load_roles!
  end  
  
  def load_roles!(list = self.role_list)
    if list.nil? || list.empty?
      @role_set = []
    else
      @role_set = list.split(' ').map {|name| name.to_sym}
    end
  end
  
  def set_role_list!(set = @role_set || nil)
    unless set.nil?
      sorted = set.sort { |a,b| a.to_s.downcase <=> b.to_s.downcase }
      of_symbols = sorted.select {|item| item.is_a? Symbol}
      self.role_list = of_symbols.join(" ")         
    end
  end
end
