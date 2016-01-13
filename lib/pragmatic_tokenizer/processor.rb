module PragmaticTokenizer
  class Processor
    attr_reader :text
    def initialize(language: Languages::Common)
      @language = language
    end

    def process(text:)
      shift_comma(text)
      shift_multiple_dash(text)
      shift_upsidedown_question_mark(text)
      shift_upsidedown_exclamation(text)
      shift_ellipse(text)
      shift_special_quotes(text)
      shift_colon(text)
      shift_bracket(text)
      shift_semicolon(text)
      shift_caret(text)
      shift_vertical_bar(text)
      convert_dbl_quotes(text)
      convert_sgl_quotes(text)
      shift_beginning_hyphen(text)
      shift_ending_hyphen(text)
      tokens = separate_full_stop(text.squeeze(' ')
        .split
        .flat_map { |t| (t[0] == '‚' || t[0] == ',') && t.length > 1 ? t.split(/(,|‚)/).flatten : t }
        .flat_map { |t| (t[-1] == '’' || t[-1] == "'") && t.length > 1 ? t.split(/(’|')/).flatten : t }
        .map { |t| convert_sym_to_punct(t) })
      separate_other_ending_punc(tokens)
    end

    private

    def convert_dbl_quotes(text)
      # Convert left double quotes to special character
      text.gsub!(/"(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
      text.gsub!(/“(?=.*\w)/o, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['“'] + ' ') || text
      # Convert remaining quotes to special character
      text.gsub!(/"/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['"'] + ' ') || text
      text.gsub!(/”/, ' ' + PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP['”'] + ' ') || text
    end

    def convert_sgl_quotes(text)
      if defined? @language::SingleQuotes
        @language::SingleQuotes.new.handle_single_quotes(text)
      else
        PragmaticTokenizer::Languages::Common::SingleQuotes.new.handle_single_quotes(text)
      end
    end

    def shift_multiple_dash(text)
      text.gsub!(/--+/o, ' - ') || text
    end

    def shift_vertical_bar(text)
      text.gsub!(/\|/, ' | ') || text
    end

    def shift_comma(text)
      # Shift commas off everything but numbers
      text.gsub!(/,(?!\d)/o, ' , ') || text
    end

    def shift_upsidedown_question_mark(text)
      text.gsub!(/¿/, ' ¿ ') || text
    end

    def shift_upsidedown_exclamation(text)
      text.gsub!(/¡/, ' ¡ ') || text
    end

    def shift_ending_hyphen(text)
      text.gsub!(/-\s+/, ' - ') || text
    end

    def shift_beginning_hyphen(text)
      text.gsub!(/\s+-/, ' - ') || text
    end

    def shift_special_quotes(text)
      text.gsub!(/«/, ' « ') || text
      text.gsub!(/»/, ' » ') || text
      text.gsub!(/„/, ' „ ') || text
      text.gsub!(/“/, ' “ ') || text
    end

    def shift_bracket(text)
      text.gsub!(/([\(\[\{\}\]\)])/o) { ' ' + $1 + ' ' } || text
    end

    def shift_colon(text)
      puts "Text: #{text}"
      return text unless text.include?(':') &&
        text.partition(':').last[0] !~ /\A\d+/ &&
        text.partition(':').first[-1] !~ /\A\d+/
      puts "YOYOYO"
      # Ignore web addresses
      text.gsub!(/(?<=[http|https]):(?=\/\/)/, PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP[":"]) || text
      text.gsub!(/:/o, ' :') || text
      text.gsub!(/(?<=\s):(?=\#)/, ': ') || text
    end

    def shift_semicolon(text)
      text.gsub!(/([;])/o) { ' ' + $1 + ' ' } || text
    end

    def shift_caret(text)
      text.gsub!(/\^/, ' ^ ') || text
    end

    def shift_ellipse(text)
      text.gsub!(/(\.\.\.+)/o) { ' ' + $1 + ' ' } || text
      text.gsub!(/(\.\.+)/o) { ' ' + $1 + ' ' } || text
      text.gsub!(/(…+)/o) { ' ' + $1 + ' ' } || text
    end

    def separate_full_stop(tokens)
      if @language.eql?(Languages::English) || @language.eql?(Languages::Common)
        abbr = {}
        @language::ABBREVIATIONS.each do |i|
          abbr[i] = true
        end
        cleaned_tokens = []
        tokens.each_with_index do |_t, i|
          if tokens[i + 1] && tokens[i] =~ /\A(.+)\.\z/
            w = $1
            unless abbr[w.downcase] || w =~ /\A[a-z]\z/i ||
              w =~ /[a-z](?:\.[a-z])+\z/i
              cleaned_tokens <<  w
              cleaned_tokens << '.'
              next
            end
          end
          cleaned_tokens << tokens[i]
        end
        if cleaned_tokens[-1] && cleaned_tokens[-1] =~ /\A(.*\w)\.\z/
          cleaned_tokens[-1] = $1
          cleaned_tokens.push '.'
        end
        cleaned_tokens
      else
        tokens.flat_map { |t| t =~ /\.\z/ && !@language::ABBREVIATIONS.include?(Unicode::downcase(t.split(".")[0])) && t.length > 2 ? t.split(".").flatten + ["."] : t }
      end
    end

    def separate_other_ending_punc(tokens)
      cleaned_tokens = []
      tokens.each do |a|
        split_punctuation = a.scan(/(?<=\S)[。．！!?？]+$/)
        if split_punctuation[0].nil?
          cleaned_tokens << a
        else
          cleaned_tokens << a.tr(split_punctuation[0],'')
          if split_punctuation[0].length.eql?(1)
            cleaned_tokens << split_punctuation[0]
          else
            split_punctuation[0].split("").each do |s|
              cleaned_tokens << s
            end
          end
        end
      end
      cleaned_tokens
    end

    def convert_sym_to_punct(token)
      symbol = /[♳ ♴ ♵ ♶ ♷ ♸ ♹ ♺ ⚀ ⚁ ⚂ ⚃ ⚄ ⚅ ☇ ☈ ☉ ☊ ☋ ☌ ☍ ☠ ☢ ☣ ☤ ☥ ☦ ☧ ☀ ☁ ☂ ☃ ☄ ☮ ♔ ♕ ♖ ♗ ♘ ♙ ♚ ⚘]/.match(token)
      if symbol.nil?
        return token
      else
        return token.gsub!(symbol[0], PragmaticTokenizer::Languages::Common::PUNCTUATION_MAP.key(symbol[0]))
      end
    end
  end
end