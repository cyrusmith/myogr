# coding: utf-8
module Distribution
  module BarcodesHelper
    def barcode_reader_tag(field_name)
      render do
        label_tag field_name, 'Введите штрихкод'
        text_field_tag field_name, nil, autofocus: true
        javascript_include_tag 'control/barcode_reader'
      end
    end
  end
end
