class User < ActiveRecord::Base
  include PublicActivity::Common
  attr_accessor :tutor_token

  has_and_belongs_to_many :events
  attr_accessible :email, :first_name, :last_name, :full_name, :password, :password_confirmation, :avatar_url, :role, :tutor_token
  has_secure_password
  # Associations
  has_many :relationships
  has_many :relations, :through => :relationships
  has_many :inverse_relationships, :class_name => "Relationship", :foreign_key => "relation_id"
  has_many :inverse_relations, :through => :inverse_relationships, :source => :user
  has_many :comments, as: :commentable

  has_many :sent_invitations, :class_name => 'Invitation', :foreign_key => 'sender_id'
  belongs_to :invitation

  # Gems
  acts_as_commentable
  acts_as_reader
  # Validations
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, with: /\A([^@\s]+)@((?:[-a-z0-9]+.)+[a-z]{2,})\Z/
  validates_presence_of :password, :on => :create
  validate :tutor_token_exists?
  # Filters
  before_save :create_user_token
  # before_create :user_token_exists?
  before_create { generate_token(:auth_token) }
  after_create :setup_tutor_relationship
  # Embedded associations
  ROLES = %w[parent student tutor]

  def role_symbols
    [role.to_sym]
  end

  def role?(role)
    self.role.to_s == role.to_s
  end

  def full_name
    [first_name, last_name].join(' ')
  end

  def full_name=(name)
    split = name.split(' ', 2)
    self.first_name = split.first
    self.last_name = split.last
  end

  def create_user_token
    begin
      self.token=SecureRandom.urlsafe_base64
    end while self.class.exists?(token: token)
  end

  def tutor_token_exists?
    errors.add(:tutor_token, 'is invalid') unless tutor_token.blank? || User.where(token: tutor_token).any?
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])    
  end

  def send_password_reset
    generate_token(:password_reset_token)    
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def unreads
    # Reading.where(user_id: current_user).count
  end

  def mark_as_read
    self.mark_as_read!
  end

  def needing_unreads_reminder_email
    self.unreads.count > 0
  end

  # def message_read
    
  # end

  private

  def setup_tutor_relationship
    unless tutor_token.blank? 
      self.relationships.create relation_id: User.find_by_token(tutor_token).try(:id)
    end
  end

end
