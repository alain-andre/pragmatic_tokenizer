require 'spec_helper'

describe PragmaticTokenizer do
  context 'Language: English (en)' do
    context '#tokenize (example strings)' do
      context 'no options selected' do
        it 'tokenizes a string #001' do
          text = "Hello world."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", "world", "."])
        end

        it 'tokenizes a string #002' do
          text = "Hello Dr. Death."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", "dr.", "death", "."])
        end

        it 'tokenizes a string #003' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", "____________________", "."])
        end

        it 'tokenizes a string #004' do
          text = "It has a state-of-the-art design."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["it", "has", "a", "state-of-the-art", "design", "."])
        end

        it 'tokenizes a string #005' do
          text = "Jan. 2015 was 20% colder than now. But not in inter- and outer-space."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["jan.", "2015", "was", "20%", "colder", "than", "now", ".", "but", "not", "in", "inter", "-", "and", "outer-space", "."])
        end

        it 'tokenizes a string #006' do
          text = 'Go to http://www.example.com.'
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["go", "to", "http://www.example.com", "."])
        end

        it 'tokenizes a string #007' do
          text = 'One of the lawyers from ‚Making a Murderer’ admitted a mistake'
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["one", "of", "the", "lawyers", "from", "‚", "making", "a", "murderer", "’", "admitted", "a", "mistake"])
        end

        it 'tokenizes a string #008' do
          text = "One of the lawyers from 'Making a Murderer' admitted a mistake"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["one", "of", "the", "lawyers", "from", "'", "making", "a", "murderer", "'", "admitted", "a", "mistake"])
        end

        it 'tokenizes a string #009' do
          text = "hello ;-) yes"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", ";", "-", ")", "yes"])
        end

        it 'tokenizes a string #010' do
          text = "hello ;)"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", ";", ")"])
        end

        it 'tokenizes a string #011' do
          text = "area &lt;0.8 cm2"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["area", "<0.8", "cm2"])
        end

        it 'tokenizes a string #012' do
          text = "area <0.8 cm2"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["area", "<0.8", "cm2"])
        end

        it 'tokenizes a string #013' do
          text = "the “Star-Trek“-Inventor"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["the", "“", "star-trek", "“", "-", "inventor"])
        end

        it 'handles numbers with symbols 2' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals", "!"])
        end

        it 'handles numbers with symbols 3' do
          text = "Hello, that will be $5 dollars. You can pay at 5:00, after it is 500."
          pt = PragmaticTokenizer::Tokenizer.new(text)
          expect(pt.tokenize).to eq(["hello", ",", "that", "will", "be", "$5", "dollars", ".", "you", "can", "pay", "at", "5:00", ",", "after", "it", "is", "500", "."])
        end
      end

      context 'option (expand_contractions)' do
        it 'tokenizes a string #001' do
          # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
          text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""
          pt = PragmaticTokenizer::Tokenizer.new(text,
            expand_contractions: true
          )
          expect(pt.tokenize).to eq(['"', 'i', 'said', ',', "'", 'what', 'are', 'you', '?', 'crazy', '?', "'", '"', 'said', 'sandowsky', '.', '"', 'i', 'cannot', 'afford', 'to', 'do', 'that', '.', '"'])
        end

        it 'tokenizes a string #002' do
          # http://nlp.stanford.edu/software/tokenizer.shtml
          text = "\"Oh, no,\" she's saying, \"our $400 blender can't handle something this hard!\""
          pt = PragmaticTokenizer::Tokenizer.new(text,
            expand_contractions: true
          )
          expect(pt.tokenize).to eq(['"', 'oh', ',', 'no', ',', '"', 'she', 'is', 'saying', ',', '"', 'our', '$400', 'blender', 'cannot', 'handle', 'something', 'this', 'hard', '!', '"'])
        end

        it 'tokenizes a string #003' do
          text = "Look for his/her account."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            expand_contractions: true
          )
          expect(pt.tokenize).to eq(["look", "for", "his", "her", "account", "."])
        end

        it 'tokenizes a string #004' do
          text = "I like apples and/or oranges."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            expand_contractions: true
          )
          expect(pt.tokenize).to eq(["i", "like", "apples", "and", "or", "oranges", "."])
        end
      end

      context 'option (clean)' do
        it 'tokenizes a string #001' do
          text = "Hello ---------------."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            clean: true
          )
          expect(pt.tokenize).to eq(["hello", "."])
        end

        it 'tokenizes a string #002' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            clean: true
          )
          expect(pt.tokenize).to eq(["hello", "."])
        end

        it 'tokenizes a string #003' do
          text = "© ABC Company 1994"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            clean: true
          )
          expect(pt.tokenize).to eq(["abc", "company", "1994"])
        end

        it 'tokenizes a string #004' do
          text = "This sentence has a long string of dots ......................."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            clean: true
          )
          expect(pt.tokenize).to eq(["this", "sentence", "has", "a", "long", "string", "of", "dots"])
        end
      end

      context 'option (classic_filter)' do
        it 'tokenizes a string #001' do
          # http://wiki.apache.org/solr/AnalyzersTokenizersTokenFilters#solr.ClassicFilterFactory
          text = "I.B.M. cat's can't"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            classic_filter: true
          )
          expect(pt.tokenize).to eq(["ibm", "cat", "can't"])
        end
      end

      context 'option (language)' do
        it 'tokenizes a string #001' do
          text = "Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en'
          )
          expect(pt.tokenize).to eq(["hello", "ms.", "piggy", ",", "this", "is", "john", ".", "we", "are", "selling", "a", "new", "fridge", "for", "$5,000", ".", "that", "is", "a", "20%", "discount", "over", "the", "nev.", "retailers", ".", "it", "is", "a", "'", "must", "buy", "'", ",", "so", "don't", "hesistate", "."])
        end

        it 'tokenizes a string #002' do
          text = "Lisa Raines, a lawyer and director of government relations
            for the Industrial Biotechnical Association, contends that a judge
            well-versed in patent law and the concerns of research-based industries
            would have ruled otherwise. And Judge Newman, a former patent lawyer,
            wrote in her dissent when the court denied a motion for a rehearing of
            the case by the full court, \'The panel's judicial legislation has
            affected an important high-technological industry, without regard
            to the consequences for research and innovation or the public interest.\'
            Says Ms. Raines, \'[The judgement] confirms our concern that the absence of
            patent lawyers on the court could prove troublesome.\'"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en'
          )
          expect(pt.tokenize).to eq(['lisa', 'raines', ',', 'a', 'lawyer', 'and', 'director', 'of', 'government', 'relations', 'for', 'the', 'industrial', 'biotechnical', 'association', ',', 'contends', 'that', 'a', 'judge', 'well-versed', 'in', 'patent', 'law', 'and', 'the', 'concerns', 'of', 'research-based', 'industries', 'would', 'have', 'ruled', 'otherwise', '.', 'and', 'judge', 'newman', ',', 'a', 'former', 'patent', 'lawyer', ',', 'wrote', 'in', 'her', 'dissent', 'when', 'the', 'court', 'denied', 'a', 'motion', 'for', 'a', 'rehearing', 'of', 'the', 'case', 'by', 'the', 'full', 'court', ',', "\'", 'the', "panel's", 'judicial', 'legislation', 'has', 'affected', 'an', 'important', 'high-technological', 'industry', ',', 'without', 'regard', 'to', 'the', 'consequences', 'for', 'research', 'and', 'innovation', 'or', 'the', 'public', 'interest', '.', '\'', 'says', 'ms.', 'raines', ',', '\'', '[', 'the', 'judgement', ']', 'confirms', 'our', 'concern', 'that', 'the', 'absence', 'of', 'patent', 'lawyers', 'on', 'the', 'court', 'could', 'prove', 'troublesome', '.', "\'"])
        end
      end

      context 'option (remove_numbers)' do
        it 'tokenizes a string #001' do
          text = "Hello, that will be $5 dollars. You can pay at 5:00, after it is 500."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            remove_numbers: true
          )
          expect(pt.tokenize).to eq(["hello", ",", "that", "will", "be", "dollars", ".", "you", "can", "pay", "at", ",", "after", "it", "is", "."])
        end
      end

      context 'option (minimum_length)' do
        it 'tokenizes a string #001' do
          text = "Let's test the minimum length of fiver."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            minimum_length: 5
          )
          expect(pt.tokenize).to eq(["let's", "minimum", "length", "fiver"])
        end
      end

      context 'option (punctuation)' do
        it 'tokenizes a string #001' do
          text = "kath. / evang"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["kath", "evang"])
        end

        it 'tokenizes a string #002' do
          text = "derStandard.at › Sport"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["derstandard.at", "sport"])
        end

        it 'tokenizes a string #003' do
          text = "hello ^^"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["hello"])
        end

        it 'tokenizes a string #004' do
          text = "This hyphen – is not...or is it? ... It's a - dash... And a horizontal ellipsis…"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["this", "hyphen", "is", "not", "or", "is", "it", "it's", "a", "dash", "and", "a", "horizontal", "ellipsis"])
        end

        it 'tokenizes a string #005' do
          text = "A sentence. One with two dots.. And with three... Or horizontal ellipsis… which are three dots too."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["a", "sentence", "one", "with", "two", "dots", "and", "with", "three", "or", "horizontal", "ellipsis", "which", "are", "three", "dots", "too"])
        end

        it 'tokenizes a string #006' do
          text = "+++ BREAKING +++ something happened; is it interesting?"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["breaking", "something", "happened", "is", "it", "interesting"])
        end

        it 'tokenizes a string #007' do
          text = "Some *interesting stuff* is __happening here__"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["some", "*interesting", "stuff*", "is", "__happening", "here__"])
        end

        it 'tokenizes a string #008' do
          text = "Hello; what is your: name @username **delete**"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["hello", "what", "is", "your", "name", "@username", "**delete**"])
        end

        it 'tokenizes a string #009' do
          text = "hello ;-) yes"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["hello", "yes"])
        end

        it 'tokenizes a string #010' do
          text = "hello ;)"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["hello"])
        end

        it 'tokenizes a string #011' do
          text = "Hello ____________________ ."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: :none
          )
          expect(pt.tokenize).to eq(["hello"])
        end

        it 'handles non-domain words with a dot 1' do
          text = "They were being helped.This is solidarity."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
            )
          expect(pt.tokenize).to eq(["they", "were", "being", "helped", "this", "is", "solidarity"])
        end

        it 'handles non-domain words with a dot 2' do
          text = "picture was taken in sept.2015"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["picture", "was", "taken", "in", "sept.", "2015"])
        end

        it 'handles non-domain words with a dot 3' do
          text = "They were being helped.This is solidarity. See the breaking news stories about X on cnn.com/europe and english.alarabiya.net, here’s a screenshot: https://t.co/s83k28f29d31s83"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["they", "were", "being", "helped", "this", "is", "solidarity", "see", "the", "breaking", "news", "stories", "about", "x", "on", "cnn.com", "europe", "and", "english.alarabiya.net", "here’s", "a", "screenshot", "https://t.co/s83k28f29d31s83"])
        end

        it 'handles numbers with symbols 1' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals"])
        end

        it 'handles numbers with symbols 2' do
          text = "Pittsburgh Steelers won 18:16 against Cincinnati Bengals!"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["pittsburgh", "steelers", "won", "18:16", "against", "cincinnati", "bengals"])
        end

        it 'handles apostrophes and quotes' do
          text = "“Data Visualization: How to Tell Stories with Data — Jeff Korhan” by @AINewsletter"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["data", "visualization", "how", "to", "tell", "stories", "with", "data", "jeff", "korhan", "by", "@ainewsletter"])
        end

        it 'handles mentions' do
          text = ".@someone I disagree"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["@someone", "i", "disagree"])
        end

        it 'handles old school emoticons 2' do
          text = "oooh! <3"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["oooh", "<3"])
        end

        it 'handles old school emoticons 3' do
          text = "@someone &lt;33"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["@someone", "<33"])
        end

        it 'handles words with a symbol prefix 1' do
          text = "Yes! /cc @someone"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["yes", "cc", "@someone"])
        end

        it 'handles words with a emoji suffix' do
          text = "Let's meet there.😝 ok?"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["let's", "meet", "there", "😝", "ok"])
        end

        it 'handles words with a symbol prefix 2' do
          text = "blah blah |photo by @someone"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["blah", "blah", "photo", "by", "@someone"])
        end

        it 'handles pseudo-contractions' do
          text = "I suggest to buy stocks that are low value+have momentum"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["i", "suggest", "to", "buy", "stocks", "that", "are", "low", "value", "have", "momentum"])
        end

        it 'handles apostrophes and quotes 1' do
          text = "Watch the video of @amandapalmer's song “Killing Type” here"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["watch", "the", "video", "of", "@amandapalmer's", "song", "killing", "type", "here"])
        end

         it 'handles apostrophes and quotes 2' do
          text = "Watch the video of @amandapalmer`s song “Killing Type” here"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["watch", "the", "video", "of", "@amandapalmer`s", "song", "killing", "type", "here"])
        end

        it 'handles numbers suffixed with a symbol' do
          text = "4 Things Marketers Must Do Better in 2016: blah"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["4", "things", "marketers", "must", "do", "better", "in", "2016", "blah"])
        end

        it 'handles words with a emoticon suffix' do
          skip "NOT IMPLEMENTED"
          text = "look, a dog with shoes☺ !!"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["look", "a", "dog", "with", "shoes", "☺"])
        end

        it 'handles hashtags 2' do
          skip "NOT IMPLEMENTED"
          text = "This is the #upper-#limit"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["this", "is", "the", "#upper", "#limit"])
        end

        it 'handles hashtags 3' do
          skip "NOT IMPLEMENTED"
          text = "The #2016-fun has just begun."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["the", "#2016", "fun", "has", "just", "begun"])
        end

        it 'identifies emojis' do
          skip "NOT IMPLEMENTED"
          text = "How bad!😝"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["how", "bad", "😝"])
        end

        it 'identifies old school emoticons' do
          skip "NOT IMPLEMENTED"
          text = 'looking forward to the new kodak super8 camera \o/'
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["looking", "forward", "to", "the", "new", "kodak", "super8", "camera", '\o/'])
        end
      end

      context 'multiple options selected' do
        it 'tokenizes a string #001' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(['his', 'name', 'is', 'mr.', 'smith'])
        end

        it 'tokenizes a string #002' do
          text = "Hello Ms. Piggy, this is John. We are selling a new fridge for $5,000. That is a 20% discount over the Nev. retailers. It is a 'MUST BUY', so don't hesistate."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            punctuation: 'only'
          )
          expect(pt.tokenize).to eq([",", ".", ".", ".", "'", "'", ",", "."])
        end

        it 'tokenizes a string #003' do
          text = "Hello the a it experiment one fine."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            remove_stop_words: true
          )
          expect(pt.tokenize).to eq(["experiment", "fine", "."])
        end

        it 'tokenizes a string #004' do
          # https://www.ibm.com/developerworks/community/blogs/nlp/entry/tokenization?lang=en
          text = "\"I said, 'what're you? Crazy?'\" said Sandowsky. \"I can't afford to do that.\""
          pt = PragmaticTokenizer::Tokenizer.new(text,
            expand_contractions: true,
            remove_stop_words: true,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["crazy", "sandowsky", "afford"])
        end

        it 'tokenizes a string #005' do
          text = "Remove III Roman Numerals and IX. with a period."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            remove_numbers: true,
            remove_roman_numerals: true
          )
          expect(pt.tokenize).to eq(["remove", "roman", "numerals", "and", ".", "with", "a", "period", "."])
        end

        it 'tokenizes a string #006' do
          text = "Hello world with a stop word experiment."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            clean: true,
            remove_numbers: true,
            minimum_length: 3,
            expand_contractions: true,
            remove_stop_words: true,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["experiment"])
        end

        it 'tokenizes a string #007' do
          text = "Hello; what is your: name @username **delete**"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            clean: true,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["hello", "what", "is", "your", "name", "username", "delete"])
        end

        it 'tokenizes a string #008' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            punctuation: 'none',
            downcase: false
          )
          expect(pt.tokenize).to eq(['His', 'name', 'is', 'Mr.', 'Smith'])
        end

        it 'tokenizes a string #009' do
          text = "Can't go tonight. Didn't finish."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            downcase: false,
            expand_contractions: true
          )
          expect(pt.tokenize).to eq(["Cannot", "go", "tonight", ".", "Did", "not", "finish", "."])
        end

        it 'tokenizes a string #010' do
          text = "Some *interesting stuff* is __happening here__"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none',
            clean: true
          )
          expect(pt.tokenize).to eq(["some", "interesting", "stuff", "is", "happening", "here"])
        end

        it 'also allows symbols for options' do
          text = 'His name is Mr. Smith.'
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: :en,
            punctuation: :none
          )
          expect(pt.tokenize).to eq(['his', 'name', 'is', 'mr.', 'smith'])
        end

        it 'handles long strings' do
          text = "Hello World. My name is Jonas. What is your name? My name is Jonas IV Smith. There it is! I found it. My name is Jonas E. Smith. Please turn to p. 55. Were Jane and co. at the party? They closed the deal with Pitt, Briggs & Co. at noon. Let's ask Jane and co. They should know. They closed the deal with Pitt, Briggs & Co. It closed yesterday. I can't see Mt. Fuji from here. St. Michael's Church is on 5th st. near the light. That is JFK Jr.'s book. I visited the U.S.A. last year. I live in the E.U. How about you? I live in the U.S. How about you? I work for the U.S. Government in Virginia. I have lived in the U.S. for 20 years. She has $100.00 in her bag. She has $100.00. It is in her bag. He teaches science (He previously worked for 5 years as an engineer.) at the local University. Her email is Jane.Doe@example.com. I sent her an email. The site is: https://www.example.50.com/new-site/awesome_content.html. Please check it out. She turned to him, 'This is great.' she said. She turned to him, \"This is great.\" she said. She turned to him, \"This is great.\" She held the book out to show him. Hello!! Long time no see. Hello?? Who is there? Hello!? Is that you? Hello?! Is that you? 1.) The first item 2.) The second item 1.) The first item. 2.) The second item. 1) The first item 2) The second item 1) The first item. 2) The second item. 1. The first item 2. The second item 1. The first item. 2. The second item. • 9. The first item • 10. The second item ⁃9. The first item ⁃10. The second item a. The first item b. The second item c. The third list item This is a sentence\ncut off in the middle because pdf. It was a cold \nnight in the city. features\ncontact manager\nevents, activities\n You can find it at N°. 1026.253.553. That is where the treasure is. She works at Yahoo! in the accounting department. We make a good team, you and I. Did you see Albert I. Jones yesterday? Thoreau argues that by simplifying one’s life, “the laws of the universe will appear less complex. . . .” \"Bohr [...] used the analogy of parallel stairways [...]\" (Smith 55). If words are left off at the end of a sentence, and that is all that is omitted, indicate the omission with ellipsis marks (preceded and followed by a space) and then indicate the end of the sentence with a period . . . . Next sentence. I never meant that.... She left the store. I wasn’t really ... well, what I mean...see . . . what I'm saying, the thing is . . . I didn’t mean it. One further habit which was somewhat weakened . . . was that of combining words into self-interpreting compounds. . . . The practice was not abandoned. . . ." * 10
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            clean: true,
            remove_numbers: true,
            minimum_length: 3,
            expand_contractions: true,
            remove_stop_words: true,
            remove_roman_numerals: true,
            punctuation: 'none'
          )
          expect(pt.tokenize).to eq(["jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned", "jonas", "jonas", "smith", "jonas", "smith", "turn", "jane", "party", "closed", "deal", "pitt", "briggs", "noon", "jane", "closed", "deal", "pitt", "briggs", "closed", "yesterday", "mt.", "fuji", "st.", "michael's", "church", "st.", "light", "jfk", "jr.", "book", "visited", "u.s.a.", "year", "live", "e.u.", "live", "u.s.", "work", "u.s.", "government", "virginia", "lived", "u.s.", "years", "bag", "bag", "teaches", "science", "worked", "years", "engineer", "local", "university", "email", "email", "site", "check", "turned", "great", "turned", "great", "turned", "great", "held", "book", "long", "time", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "item", "list", "item", "sentence", "cut", "middle", "pdf", "cold", "night", "city", "features", "contact", "manager", "events", "activities", "treasure", "works", "yahoo", "accounting", "department", "good", "team", "albert", "jones", "yesterday", "thoreau", "argues", "simplifying", "one’s", "life", "laws", "universe", "complex", "bohr", "analogy", "parallel", "stairways", "smith", "left", "sentence", "omission", "ellipsis", "marks", "preceded", "space", "sentence", "period", "sentence", "meant", "left", "store", "habit", "weakened", "combining", "self-interpreting", "compounds", "practice", "abandoned"])
        end

        it 'handles markdown' do
          text = "This is _bold_ and this is *italic*"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none',
            clean: true
          )
          expect(pt.tokenize).to eq(["this", "is", "bold", "and", "this", "is", "italic"])
        end

        it 'handles single quotes' do
          text = "Recognised as one of the ‘good’ games."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            clean: true,
            remove_numbers: true,
            minimum_length: 3,
            expand_contractions: true,
            remove_stop_words: true,
            punctuation: :none,
            downcase: true)
          expect(pt.tokenize).to eq(["recognised", "good", "games"])
        end

        it 'removes control characters' do
          text = "\u0000 \u001F \u007FHello test."
          pt = PragmaticTokenizer::Tokenizer.new(text,
            language: 'en',
            clean: true
          )
          expect(pt.tokenize).to eq(["hello", "test", "."])
        end

        # this would require a configurable option that splits a word at each hyphen
        # as soon its total length is > n characters.
        it 'splits too long words with hypens' do
          skip "NOT IMPLEMENTED"
          text = "hi-hat and old-school but not really-important-long-word"
          pt = PragmaticTokenizer::Tokenizer.new(text,
            punctuation: 'none',
            long_word_split: 12
          )
          expect(pt.tokenize).to eq(["hi-hat", "and", "old-school", "but", "not", "really", "important", "long", "word"])
        end
      end
    end

    context 'other methods' do
      context 'hashtags' do
        it 'finds all valid hashtags #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the #fun #hashtags and only give me #backallofthem.')
          expect(pt.hashtags).to eq(['#fun', '#hashtags', '#backallofthem'])
        end

        it 'finds all valid hashtags #002' do
          pt = PragmaticTokenizer::Tokenizer.new('#fun #hashtags and only give me ＃backallofthem')
          expect(pt.hashtags).to eq(['#fun', '#hashtags', '＃backallofthem'])
        end
      end

      context 'urls' do
        it 'finds all valid urls #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out http://www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["http://www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #002' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out https://www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["https://www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #003' do
          pt = PragmaticTokenizer::Tokenizer.new('Check out www.google.com/?this_is_a_url/hello-world.html for more info.')
          expect(pt.urls).to eq(["www.google.com/?this_is_a_url/hello-world.html"])
        end

        it 'finds all valid urls #004' do
          pt = PragmaticTokenizer::Tokenizer.new('Go to http://www.example.com.')
          expect(pt.urls).to eq(["http://www.example.com"])
        end
      end

      context 'domains' do
        it 'finds all valid domains #001' do
          pt = PragmaticTokenizer::Tokenizer.new('See the breaking news stories about X on cnn.com/europe and english.alarabiya.net, here’s a screenshot: https://t.co/s83k28f29d31s83')
          expect(pt.domains).to eq(['cnn.com/europe', 'english.alarabiya.net'])
        end
      end

      context 'emails' do
        it 'finds all valid emails #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Please email example@example.com for more info.')
          expect(pt.emails).to eq(['example@example.com'])
        end

        it 'finds all valid emails #002' do
          pt = PragmaticTokenizer::Tokenizer.new('123@gmail.com Please email example@example.com for more info. test@hotmail.com')
          expect(pt.emails).to eq(['123@gmail.com', 'example@example.com', 'test@hotmail.com'])
        end

        it 'finds all valid emails #003' do
          pt = PragmaticTokenizer::Tokenizer.new('123@gmail.com.')
          expect(pt.emails).to eq(['123@gmail.com'])
        end
      end

      context 'mentions' do
        it 'finds all valid @ mentions #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the @johnny and @space mentions @john.')
          expect(pt.mentions).to eq(['@johnny', '@space', '@john'])
        end

        it 'finds all valid @ mentions #002' do
          pt = PragmaticTokenizer::Tokenizer.new('Find me all the ＠awesome mentions.')
          expect(pt.mentions).to eq(["＠awesome"])
        end
      end

      context 'emoticons' do
        it 'finds simple emoticons #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Hello ;-) :) 😄')
          expect(pt.emoticons).to eq([';-)', ':)'])
        end
      end

      context 'emoji' do
        it 'finds all valid emoji #001' do
          pt = PragmaticTokenizer::Tokenizer.new('Hello ;-) :) 😄')
          expect(pt.emoji).to eq(['😄'])
        end

        it 'finds all valid emoji #002' do
          pt = PragmaticTokenizer::Tokenizer.new('I am a string with emoji 😍😍😱😱👿👿🐔🌚 and some other Unicode characters 比如中文 and numbers 55 33.')
          expect(pt.emoji).to eq(["😍", "😍", "😱", "😱", "👿", "👿", "🐔", "🌚"])
        end

        it 'finds all valid emoji #003' do
          pt = PragmaticTokenizer::Tokenizer.new("Return the emoji 👿😍😱🐔🌚.")
          expect(pt.emoji).to eq(["👿", "😍", "😱", "🐔", "🌚"])
        end
      end
    end

    context 'ending punctutation' do
      it 'handles ending question marks' do
        text = 'What is your name?'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["what", "is", "your", "name", "?"])
      end

      it 'handles exclamation points' do
        text = 'You are the best!'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["you", "are", "the", "best", "!"])
      end

      it 'handles periods' do
        text = 'This way a productive day.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "way", "a", "productive", "day", "."])
      end

      it 'handles quotation marks' do
        text = "\"He is not the one you are looking for.\""
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["\"", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "\""])
      end

      it 'handles single quotation marks' do
        text = "'He is not the one you are looking for.'"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["'", "he", "is", "not", "the", "one", "you", "are", "looking", "for", ".", "'"])
      end

      it "handles single quotation marks ('twas)" do
        text = "'Twas the night before Christmas and 'twas cloudy."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["'twas", "the", "night", "before", "christmas", "and", "'twas", "cloudy", "."])
      end

      it 'handles double quotes at the end of a sentence' do
        text = "She said, \"I love cake.\""
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\""])
      end

      it 'handles double quotes at the beginning of a sentence' do
        text = "\"I love cake.\", she said to her friend."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["\"", "i", "love", "cake", ".", "\"", ",", "she", "said", "to", "her", "friend", "."])
      end

      it 'handles double quotes in the middle of a sentence' do
        text = "She said, \"I love cake.\" to her friend."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "said", ",", "\"", "i", "love", "cake", ".", "\"", "to", "her", "friend", "."])
      end
    end

    context 'other punctutation' do
      it 'handles ellipses' do
        text = 'Today is the last day...'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['today', 'is', 'the', 'last', 'day', '...'])
      end

      it 'handles special quotes' do
        text = "«That's right», he said."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["«", "that's", "right", "»", ",", "he", "said", "."])
      end

      it 'handles upside down punctuation (¿)' do
        text = "¿Really?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["¿", "really", "?"])
      end

      it 'handles upside down punctuation (¡)' do
        text = "¡Really!"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["¡", "really", "!"])
      end

      it 'handles colons' do
        text = "This was the news: 'Today is the day!'"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "was", "the", "news", ":", "'", "today", "is", "the", "day", "!", "'"])
      end

      it 'handles web addresses' do
        text = "Please visit the site - https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "visit", "the", "site", "-", "https://www.tm-town.com"])
      end

      it 'handles multiple colons and web addresses' do
        text = "Please visit the site: https://www.tm-town.com"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "visit", "the", "site", ":", "https://www.tm-town.com"])
      end

      it 'handles multiple dashes' do
        text = "John--here is your ticket."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["john", "-", "here", "is", "your", "ticket", "."])
      end

      it 'handles brackets' do
        text = "This is an array: ['Hello']."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "an", "array", ":", "[", "'", "hello", "'", "]", "."])
      end

      it 'handles double question marks' do
        text = "This is a question??"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "a", "question", "?", "?"])
      end

      it 'handles multiple ending punctuation' do
        text = "This is a question?!?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["this", "is", "a", "question", "?", "!", "?"])
      end

      it 'handles contractions 1' do
        text = "How'd it go yesterday?"
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["how'd", "it", "go", "yesterday", "?"])
      end

      it 'handles contractions 2' do
        text = "You shouldn't worry."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["you", "shouldn't", "worry", "."])
      end

      it 'handles contractions 3' do
        text = "We've gone too far. It'll be over when we're done."
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["we've", "gone", "too", "far", ".", "it'll", "be", "over", "when", "we're", "done", "."])
      end

      it 'handles numbers' do
        text = 'He paid $10,000,000 for the new house which is equivalent to ¥1,000,000,000.00.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['he', 'paid', '$10,000,000', 'for', 'the', 'new', 'house', 'which', 'is', 'equivalent', 'to', '¥1,000,000,000.00', '.'])
      end

      it 'follows the Chicago Manual of Style on punctuation' do
        text = 'An abbreviation that ends with a period must not be left hanging without it (in parentheses, e.g.), and a sentence containing a parenthesis must itself have terminal punctuation (are we almost done?).'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['an', 'abbreviation', 'that', 'ends', 'with', 'a', 'period', 'must', 'not', 'be', 'left', 'hanging', 'without', 'it', '(', 'in', 'parentheses', ',', 'e.g.', ')', ',', 'and', 'a', 'sentence', 'containing', 'a', 'parenthesis', 'must', 'itself', 'have', 'terminal', 'punctuation', '(', 'are', 'we', 'almost', 'done', '?', ')', '.'])
      end

      it 'is case insensitive' do
        text = 'his name is mr. smith, king of the \'entire\' forest.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['his', 'name', 'is', 'mr.', 'smith', ',', 'king', 'of', 'the', '\'', 'entire', '\'', 'forest', '.'])
      end

      it 'handles web url addresses #1' do
        text = 'Check out http://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "http://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #2' do
        text = 'Check out https://www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "https://www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles web url addresses #3' do
        text = 'Check out www.google.com/?this_is_a_url/hello-world.html for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["check", "out", "www.google.com/?this_is_a_url/hello-world.html", "for", "more", "info", "."])
      end

      it 'handles email addresses' do
        text = 'Please email example@example.com for more info.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["please", "email", "example@example.com", "for", "more", "info", "."])
      end

      it 'handles empty tokens' do
        text = "!!!!! https://t.co/xxxx"
        pt = PragmaticTokenizer::Tokenizer.new(text,
          punctuation: 'none'
        )
        expect(pt.tokenize).to eq(["https://t.co/xxxx"])
      end
    end

    context 'abbreviations' do
      it 'handles military abbreviations' do
        text = 'His name is Col. Smith.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["his", "name", "is", "col.", "smith", "."])
      end

      it 'handles institution abbreviations' do
        text = 'She went to East Univ. to get her degree.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["she", "went", "to", "east", "univ.", "to", "get", "her", "degree", "."])
      end

      it 'handles company abbreviations' do
        text = 'He works at ABC Inc. on weekends.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "works", "at", "abc", "inc.", "on", "weekends", "."])
      end

      it 'handles old state abbreviations' do
        text = 'He went to school in Mass. back in the day.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "went", "to", "school", "in", "mass.", "back", "in", "the", "day", "."])
      end

      it 'handles month abbreviations' do
        text = 'It is cold in Jan. they say.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["it", "is", "cold", "in", "jan.", "they", "say", "."])
      end

      it 'handles miscellaneous abbreviations' do
        text = '1, 2, 3, etc. is the beat.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['1', ',', '2', ',', '3', ',', 'etc.', 'is', 'the', 'beat', '.'])
      end

      it 'handles one letter abbreviations (i.e. Alfred E. Stone)' do
        text = 'Alfred E. Stone is a person.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["alfred", "e.", "stone", "is", "a", "person", "."])
      end

      it 'handles repeating letter-dot words (i.e. U.S.A. or J.C. Penney)' do
        text = 'The U.S.A. is a country.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["the", "u.s.a.", "is", "a", "country", "."])
      end

      it 'handles abbreviations that occur at the end of a sentence' do
        text = 'He works at ABC Inc.'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(["he", "works", "at", "abc", "inc", "."])
      end

      it 'handles punctuation after an abbreviation' do
        text = 'Exclamation point requires both marks (Q.E.D.!).'
        expect(PragmaticTokenizer::Tokenizer.new(text).tokenize).to eq(['exclamation', 'point', 'requires', 'both', 'marks', '(', 'q.e.d.', '!', ')', '.'])
      end
    end
  end
end