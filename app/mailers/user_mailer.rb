# encoding: UTF-8
class UserMailer < ActionMailer::Base
	include ApplicationHelper

  default :from => Config::Configuration.get(:ssg, :email_address), :to => Config::Configuration.get(:ssg, :notify_address)

  def verify(user, url)

  	@user = user
  	@url = url + verify_users_path() + "?id=#{@user.id}&uuid=#{@user.uuid}"

	  using_locale(user.locale) { mail(:to => @user.email, :subject => t('users.verify.email_subject')) }
  end

  def created(user, url)
    @community_user = user
    @url = url

    using_locale(user.locale) { mail(:to => @community_user.email, :subject => 'Kreiran je problem za Vašu općinu') }
  end

  def notify_created(city, url)
    @city = city
    @url  = url

    mail(:subject => "Kreiran je problem za općinu #{city.name}")
  end

  def reset_password(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token
    using_locale(user.locale) { mail(:to => @user.email, :subject => t('users.verify.reset_pass')) }
  end

  def notify_admin_user_creation(user, token, url)
    @user = user
    @url = url + reset_password_users_path() + "?token=" + token + "&set_pwd=true"
    using_locale(user.locale) { mail(:to => @user.email, :subject => "Kreiran Vam je administratorski nalog na ULICA.BA") }
  end

  def notify_issue_updated(user, updated_by_user, issue)
    @user = user
    @updated_by_user = updated_by_user
    @issue = issue

    using_locale(user.locale) { mail(:to => @user.email, :subject => t('users.notify.issue_updated')) }
  end

  def send_contact_message(subject, message, name, email)
    @subject = subject
    @message = message
    @name = name
    @email = email

    mail(:subject => "New message from ULICA.BA: #{@subject} ")
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