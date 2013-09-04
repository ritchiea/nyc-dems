class AddIpAddressToEndorsements < ActiveRecord::Migration
  def change
    add_column :endorsements, :ip_address, :string
  end
end
