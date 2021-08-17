class CreateTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :tokens do |t|
      t.string :auth_token
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
