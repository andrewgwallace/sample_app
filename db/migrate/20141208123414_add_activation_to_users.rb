class AddActivationToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activation_digest, :string
    add_column :users, :activated, :boolean, default: false #Listing 10.2
    add_column :users, :activated_at, :datetime
  end
end
