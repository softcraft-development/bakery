class User < ActiveRecord::Base
  ROLE_DELIMITER = ' '
  
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
    
  has_many :recipes

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :role_list
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
      @role_set = list.split(ROLE_DELIMITER).map {|token| User.get_role(token) }
    end
  end
  
  def set_role_list!(set = @role_set || nil)
    unless set.nil?
      sorted = set.sort { |a,b| a.to_s.downcase <=> b.to_s.downcase }
      of_symbols = sorted.select {|item| item.is_a? Symbol}
      of_tokens = of_symbols.select {|symbol| User.get_role_token(symbol) }
      self.role_list = of_tokens.join(ROLE_DELIMITER)         
    end
  end
  
  def self.get_role(role_token)
    return role_token.to_s.to_sym
  end
  
  def self.get_role_token(role)
    return role.to_sym.to_s
  end
  
  def self.having_role(role)
    role_token = User.get_role_token(role)
    search = "%" + ROLE_DELIMITER + role_token + ROLE_DELIMITER + "%"
    where("'#{ROLE_DELIMITER}' || role_list || '#{ROLE_DELIMITER}' like ?", search )
  end

  scope :admins, having_role(:admin)
end
