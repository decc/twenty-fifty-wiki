class User < ActiveRecord::Base
  
  before_validation :set_title_from_email
  after_create :tell_administrator_about_new_user
  
  include PreProcessContent  
  include DeletableExtension  
  include AutolinkTitle
  include Sokcloth
  include Versioned
  include CategoryMembershipExtension
  include Followers
  include SignOff
  include Searchable
    
  default_scope order('LOWER(title) ASC')
  
  has_many :pages
  has_many :edits, :class_name => 'Version'
  
  has_many :followed_things, :class_name => 'Following'
  
  %w{pages pictures categories users costs cost_categories cost_sources}.each do |type|
    has_many "signed_off_#{type}", :class_name => type.classify, :foreign_key => :signed_off_by_id
    has_many "followed_#{type}", :through => :followed_things, :source => :target, :source_type => type.classify
  end
  
  def signed_off_all_types
    signed_off_pages + signed_off_pictures + signed_off_categories + signed_off_users + signed_off_costs + signed_off_cost_categories + signed_off_cost_sources
  end
  
  def followed_all_types
    followed_pages + followed_pictures + followed_categories + followed_users + followed_costs + followed_cost_categories + followed_cost_sources
  end
  
  def followed_versions(since = 1.hour.ago)
    (followed_all_types.map do |t|
      t.versions.where(['updated_at > ?',since])
    end + 
    followed_categories.map(&:child_category_memberships).flatten.map(&:target).map { |t| t.versions.where(['updated_at > ?',since]) } +
    followed_cost_categories.map(&:costs).flatten.map { |t| t.versions.where(['updated_at > ?',since]) } +
    followed_cost_sources.map(&:costs).flatten.map { |t| t.versions.where(['updated_at > ?',since]) }).flatten.uniq
  end
  
  # Picture of this user
  has_attached_file :picture
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :authenticatable, :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :title, :content, :picture, :previous_version_id
  
  def User.current=(user)
    Thread.current[:user] = user
  end
  
  def User.current
    Thread.current[:user]
  end
  
  def name; self.title; end
  
  before_save   :update_sortable_name
  
  def set_title_from_email
    return true unless title.blank?
    return true if email.blank?
    return true unless email.strip =~ /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i
    address = email.split('@')
    # Try just the name
    name = address.first.split('.').map(&:capitalize).join(' ')
    possible_tail = address.last.split('.').map(&:capitalize)
    actual_tail = []
    self.title = name
    # If it exists already, try adding the first part of the email domain
    while User.find_by_title(self.title)
      possible_tail << Time.now.to_s if possible_tail.empty?  
      actual_tail << possible_tail.shift
      self.title = "#{name} (#{actual_tail.join(' ')})"
    end
    true
  end
  
  def update_sortable_name
    return nil unless title_changed? && title
    self.sortable_name = title.split(' ').reverse.join(', ').downcase
  end
  
  def ast
    @ast ||= SokclothParser.parse(self.content)
  end
  
  def ast_for_insertion
    @ast_for_insertion ||= 
    NonTerminalNode.from_array([:sokcloth,[:heading,'0',title],[:image, picture.url(:thumb),"/users/#{id}"],SokclothParser.parse(content)])
  end
  
  alias :ast_for_latex_insertion :ast_for_insertion
  
  def ast_for_summary
    @ast_for_summary ||=
      NonTerminalNode.from_array([:sokcloth,
        [:div,'user',
          [:image, picture.url(:thumb),"/users/#{id}"],
          [:heading,'0',title],
          SokclothParser.parse(content).first_matching_node(:paragraph),
          [:paragraph,[:plain_text,"Read more about #{title}."]]
        ]
      ])
  end
  
  def redirects_to_page; false; end
  
  def active_for_authentication?
    super && is_on_the_list_of_permitted_users?
  end
  
  def inactive_message
    is_on_the_list_of_permitted_users? ? super : :not_on_list_of_permitted_users
  end
  
  def is_on_the_list_of_permitted_users?
    return true unless AppConfig.id_of_page_to_check_emails_against
    return false unless @page = Page.find(AppConfig.id_of_page_to_check_emails_against)
    valid_emails = @page.content.split.map do |email|
      email =~ /^[#*]+(.*?)$/ ? $1.strip.downcase : email.strip.downcase
    end
    valid_emails.include?(email.strip.downcase)
  end
  
  def tell_administrator_about_new_user
    ChangeNotifications.new_user(self).deliver
    true
  end
  
end
