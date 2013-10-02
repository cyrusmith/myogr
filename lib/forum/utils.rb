# encoding: utf-8
module Forum
  class Utils
    SPECIAL_CHARACTERS_MAP = {
        '!' => '&#33;',
        '\'' => '&#39;',
        '$' => '&#036;',
        '♥' => '&#9829;',
        '\\' => '&#092;',
        '|' => '&#124;',
        '&' => '&amp;',
    }

    def self.escape(value)
      value.to_s.gsub(/[!'$♥\|&]/) { |s| SPECIAL_CHARACTERS_MAP[s] }
    end
  end
end