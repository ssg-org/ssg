# ULICA.BA HACK-DAY

## HACKDAY RULES

* Send your github username to pasalic.zaharije@gmail.com
* Everyboady will have read/write access to this repository
* If somebady wanna add changes after hackday - do pull request
* Create branch for each feature
* If you dont know RoR - pair with somebady that know
* Happy coding :)

## WINDOWS

* Create github account 
* Install Imagemagick - http://www.imagemagick.org/
* Install Rails Installer (http://railsinstaller.org/en) 
* After installation has finished, your public key will be copied into clipboard. Open
github and add new ssh key

```
git clone git@github.com:zpasal/ssg.git
cd ssg
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
```

* Set SSL Root certificates

```
ruby ssl_patch.rb
set SSL_CERT_FILE=C:\RailsInstaller\cacert.pem
```

* start server

```
bundle exec rails s
```

* Allow access to firewall if Windows asks


## MAC
* Create github account
* Install Ruby 1.9.3 via RVM (https://rvm.io/)
* Install Imagemagic  
  * Macports (http://www.macports.org/) or
  * Native (http://www.imagemagick.org/)
* Clone repository and bundle

```
git clone git@github.com:zpasal/ssg.git
cd ssg
bundle
bundle exec rake db:migrate
bundle exec rake db:seed
bundle exec rails s
```
