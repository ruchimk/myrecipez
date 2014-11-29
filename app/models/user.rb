class User < ActiveRecord::Base
  has_secure_password

  validates_uniqueness_of :email

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def self.from_omniauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
