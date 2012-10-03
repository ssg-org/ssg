rm db/development.sqlite3
rm -rf public/uploads
rake db:migrate
rake db:seed
