# encoding: UTF-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

City.create({ :name => 'Banja Luka', :lat =>  44.766667, :long => 17.183333 })
City.create({ :name => 'Bihać', :lat =>  44.819838, :long => 15.871875 })
City.create({ :name => 'Bijeljina', :lat =>  44.75, :long => 19.216667 })
City.create({ :name => 'Bosanska Krupa', :lat =>  44.883456, :long => 16.152788 })
City.create({ :name => 'Brčko', :lat =>  44.87, :long => 18.81 })
City.create({ :name => 'Čapljina', :lat =>  43.112497, :long => 17.714575 })
City.create({ :name => 'Čitluk', :lat =>  45.15, :long => 16.65 })
City.create({ :name => 'Gradačac', :lat =>  44.874722, :long => 18.4291 })
City.create({ :name => 'Grude', :lat =>  43.37727, :long => 17.395981 })
City.create({ :name => 'Jajce', :lat =>  44.340809, :long => 17.257441 })
City.create({ :name => 'Mostar', :lat =>  43.344044, :long => 17.801199 })
City.create({ :name => 'Pale', :lat =>  43.816667, :long => 18.566667 })
City.create({ :name => 'Sarajevo - Centar', :lat =>  43.857361, :long => 18.413445 })
City.create({ :name => 'Sarajevo - Hadžići', :lat =>  43.823282, :long => 18.221108 })
City.create({ :name => 'Sarajevo - Ilidža', :lat =>  43.829056, :long => 18.303925 })
City.create({ :name => 'Sarajevo - Novi Grad', :lat =>  43.841708, :long => 18.347683 })
City.create({ :name => 'Sarajevo - Novo Sarajevo', :lat =>  43.851822, :long => 18.383984 })
City.create({ :name => 'Sarajevo - Stari Grad', :lat =>  43.859187, :long => 18.430247 })
City.create({ :name => 'Sarajevo - Vogošća', :lat =>  43.900491, :long => 18.345312 })
City.create({ :name => 'Široki Brijeg', :lat =>  43.366667, :long => 17.583333 })
City.create({ :name => 'Travnik', :lat =>  44.222321, :long => 17.6651 })
City.create({ :name => 'Tuzla', :lat =>  444.532841, :long => 18.6705 })
City.create({ :name => 'Zenica', :lat =>  44.198116, :long => 17.915890  })

Category.create({ :name => 'Parkiranje', :color => '44A8D6', :icon => 'parkiranje.png' })
Category.create({ :name => 'Fasade',  :color => 'E23408', :icon => 'fasade.png'  })
Category.create({ :name => 'Okolina', :color => '9ecc3b', :icon => 'okolina.png'  })
Category.create({ :name => 'Rasvjeta', :color => 'ffc80c', :icon => 'rasvjeta.png'  })
Category.create({ :name => 'Putevi',  :color => '683b17', :icon => 'putevi.png'  })
