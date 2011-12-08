class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.string :key
      t.string :secret
      t.string :website
      t.string :latitude
      t.string :longitude
      t.string :twitter
      t.string :klass

      t.timestamps
    end
    Area.create(:name => 'Mt. Bachelor', :twitter => 'mtbachelor', :klass => 'Bachelor')
  end
end
