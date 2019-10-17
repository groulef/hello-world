require 'date'
require 'pony'
require 'dotenv/load'

class PrintLetter
  def initialize
    @now = DateTime.now
    @index = @now.cweek - 43
    @index += 52 if @index < 0
    @wday = @now.wday
    @letters = [
      "h", "h", "h",
      "",
      "e", "e", "e",
      "",
      "l", "l",
      "",
      "l", "l",
      "",
      "o", "o", "o",
      "",
      "",
      "w", "w", "w", "w", "w", "w", "w",
      "",
      "o", "o", "o",
      "",
      "r", "r", "r",
      "",
      "l", "l",
      "",
      "d", "d", "d",
      "",
      "bang",
      "",
      ""
    ]
  end

  def commit
    filename = @now.to_s
    system("touch /home/havokx/hello-world/#{filename}")
    system("cd /home/havokx/hello-world/ && git add #{filename} && git commit -m 'Add #{filename}' && git push")
  end

  def perform
    send(@letters[@index])
  end

  def h
    case @index
    when 0,2
      commit
    when 1
      commit if [3].include? @wday
    end
  end

  def e
    case @index
    when 4
      commit
    when 5
      commit if [0, 3, 6].include? @wday
    when 6
      commit if [0, 6].include? @wday
    end
  end

  def l
    case @index
    when 8, 11, 35
      commit
    when 9, 12, 36
      commit if [6].include? @wday
    end
  end

  def o
    case @index
    when 14, 16, 27, 29
      commit
    when 15, 28
      commit if [0, 6].include? @wday
    end
  end

  def w
    case @index
    when 19, 25
      commit if [0, 1, 2].include? @wday
    when 20, 22, 24
      commit if [3, 4, 5].include? @wday
    when 21, 23
      commit if [0, 1, 2, 6].include? @wday
    end
  end

  def r
    case @index
    when 31
      commit
    when 32
      commit if [0, 3].include? @wday
    when 33
      commit if [0, 1, 2, 4, 5, 6].include? @wday
    end
  end

  def d
    case @index
    when 38
      commit
    when 39
      commit if [1, 5].include? @wday
    when 40
      commit if [2, 3, 4].include? @wday
    end
  end

  def bang
    case @index
    when 43
      commit if [0, 1, 2, 3, 4, 6].include? @wday
    end
  end

  def method_missing(m, *args, &block)
  end
end

begin
  PrintLetter.new.perform
rescue => exception
  Pony.options = {
    :subject => "Failed to commit to Github.",
    :html_body => "Failed to commit today.",
    :via => :smtp,
    :from => ENV["SMTP_USER"],
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name 			  => ENV["SMTP_USER"],
      :password             => ENV["SMTP_PASSWORD"],
      :authentication       => :plain
    }
  }

  Pony.mail(:to => ENV["TARGET"])
end
