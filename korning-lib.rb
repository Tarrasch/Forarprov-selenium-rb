class Goer # I must class it to test it
  def self.go(raw_lines)
    body = raw_lines.select { |x| Goer::text_is_good(x) }
    Goer::notify_user("OMG", body.join("\n")) if body != []

  end

  def self.text_is_good(raw_string)
    date = Date.parse raw_string rescue Date.parse("2020-10-10")
    date < Date.today + 28
  end

  # This will be a bit system dependent
  def self.notify_user(title, body)
    puts "#{title}:\n#{body}\n"
    `notify-send '#{title}' '#{body}'` # Ubuntu notification
    `ogg123 /usr/share/sounds/gnome/default/alerts/*.ogg`
  end
end
