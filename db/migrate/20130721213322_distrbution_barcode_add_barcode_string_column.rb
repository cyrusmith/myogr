class DistrbutionBarcodeAddBarcodeStringColumn < ActiveRecord::Migration
  def change
    add_column :distribution_barcodes, :barcode_string, :string
    add_index :distribution_barcodes, :barcode_string
  end
end
