# encoding: UTF-8
class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address)

  def verify(user, url)

  	@user = user
  	@url = url + verify_users_path() + "?id=#{@user.id}&uuid=#{@user.uuid}"

    #?id=8&uuid=801faacb-979b-44e1-b6eb-eb264699fa15

	  using_locale(user.locale) { mail(:to => @user.email, :subject => t('users.verify.email_subject')) }
  end

  def created(user, url)
    @community_user = user
    @url = url

    using_locale(user.locale) { mail(:to => @community_user.email, :subject => 'Kreiran je problem za Vašu opštinu') }
  end

  def notify_created(city, url)
    @city = city
    @url  = url

    mail(:to => Config::Configuration.get(:ssg, :notify_address), :subject => "Kreiran je problem za opštinu #{city.name}")
  end

  def reset_password(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token
    using_locale(user.locale) { mail(:to => @user.email, :subject => t('users.verify.reset_pass')) }
  end

  def notify_admin_user_creation(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token + "&set_pwd=true"
    using_locale(user.locale) { mail(:to => @user.email, :subject => "Kreiran Vam je administratorski nalog na ULICA.ba") }
  end

  protected

  def using_locale(locale, &block)
    original_locale = I18n.locale
    I18n.locale = locale
    return_value = yield
    I18n.locale = original_locale
    return_value
  end
end