class Language
  def initialize(language)
    @words = language
  end

  def combinations(max_length, min_length = 1)
    combos = Array.new
    @words.each { |word| combos.push word if (min_length..max_length).include? word.length }

    begin
      keep_going = false
      new_words = Array.new
      combos.each do |combo|
        @words.each do |word|
          w = combo + word
          if ((min_length..max_length).include? w.length) and not combos.include? w
            keep_going = true
            new_words.push w
          end
        end
      end
      combos += new_words
    end while keep_going

    combos.uniq.sort { |a, b| (a.length <=> b.length) != 0 ? a.length <=> b.length : a <=> b }
  end
end

Shoes.app :width => 400, :height => 200 do
  background rgb(0.4, 0.4, 0.9, 1.0)
  bubble_gradient self, 25, 400, 0.75

  flow :margin => 10 do
    stack :width => 125 do
      para 'language'
      @lang_edit = edit_line :width => 100
      flow :margin_top => 10 do
        stack :width => 0.5 do
          para 'min'
          @min_edit = edit_line :width => 40, :text => '1'
        end
        stack :width => 0.5 do
          para 'max'
          @length_edit = edit_line :width => 40
        end
      end
      stack :margin_top => 10 do
        button 'process' do
          strings = Language.new(@lang_edit.text.split).combinations(@length_edit.text.to_i, @min_edit.text.to_i)
          @string_count.replace strings.length.to_s + ' strings'
          @strings_box.text = strings.join(', ') #(strings.map {|s| '(' + s + ')' }).join(", ")
        end
      end
    end
    stack :width => -125, :margin_left => 10 do
      @string_count = caption 'strings'
      @strings_box = edit_box :scroll => true
    end
  end
end

def bubble_gradient(app, bubble_size, bubble_count, height_percentage)
  app.nostroke
  bubble_count.times do
    center_x = (0..app.width).rand
    x = center_x - bubble_size / 2
    center_y = (0..app.height * height_percentage).rand
    y = center_y - bubble_size / 2 + app.height * (1 - height_percentage)
    app.fill rgb(0.9, 0.9, 0.9, center_y / (app.height * height_percentage))
    app.oval x, y, bubble_size, bubble_size
  end
end
