module UserSupport
  def default_user
    @default_user ||= User.create!
  end
end
