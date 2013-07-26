require_relative '../../test_helper'
class CreateThings < ActiveRecord::Migration
  def change
    create_table :things do |t|
      t.string :name
      t.string :attachment
      t.timestamps
    end
  end
end
