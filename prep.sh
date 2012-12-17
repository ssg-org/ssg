rm db/development.sqlite3
rm -rf public/uploads
./be rake db:migrate --trace
./be rake db:seed --trace
