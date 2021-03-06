class User < ActiveRecord::Base
  include Hello::User

  # don't want usernames?
  # just comment out the line below
  # we strongly recommend the field exists in case your CEO ever ever ever changes their mind
  validates_presence_of :username

  # specify what happens to associated records when the user decided to terminate their account
  # has_many :things_to_destroy,  dependent: :destroy
  # has_many :things_to_nulify,   dependent: :nullify
  # has_many :things_to_restrict, dependent: :restrict_with_error





  def to_param
    username
  end

  def to_json_web_api
    attributes.reject { |k, v| k.include?("password") }
  end



  # hello authorization

  def guest?
    %w(guest).include? role
  end

  def onboarding?
    %w(onboarding).include? role
  end

  def user?
    %w(user webmaster).include? role
  end

  def webmaster?
    %w(webmaster).include? role
  end

end
