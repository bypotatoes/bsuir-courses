class Kotd2
  def self.count_function(link)
    name_b = ENV['NAME'] ? ENV['NAME'].downcase : ' '
    criteria_b = ENV['CRITERIA'] ? ENV['CRITERIA'].downcase : /\w/
    page = link.click
    txt_link = link.text.split('(')[0].strip!
    txt_link.sub('vs.', 'vs')
    name_batler = Array.new
    name_batler[0] = txt_link.split('vs')[0].strip
    name_batler[1] = txt_link.split('vs')[1].strip
    if name_b != ' '
      if name_b != name_batler[0].downcase && name_b != name_batler[1].downcase
        return nil
      end
    end
    txt = page.css('.lyrics p').text
    count = 0
    count_batler = Array.new(2, 0)
    txt = txt.split("\n\n")
    flag = 2
    txt.length.times do |i|
      txt[i] = txt[i].downcase
      count = txt[i].scan(criteria_b).size
      if txt[i][0..30].include? name_batler[0].downcase
        count_batler[0] += count
        flag = 0
        next
      end
      if txt[i][0..30].include? name_batler[1].downcase
        count_batler[1] += count
        flag = 1
        next
      end
      if txt[i].scan(/\w/).size > 150
        if flag == 2
          next
        else
          count_batler[flag] += count
        end
      end
    end
    count = 2
    if count_batler[0].zero? || count_batler[1].zero?
      return nil
    end
    if count_batler[0] == count_batler[1]
      str = 'Dead heat!!!'
    else
      x = count_batler[0] > count_batler[1] ? 0 : 1
      str = "#{name_batler[x]} REAL NIGGA!!!"
      count = name_b == name_batler[x].downcase ? 0 : 1
    end
    puts "\n#{name_batler[0]} vs #{name_batler[1]} - #{link.uri}"
    puts "#{name_batler[0]} - #{count_batler[0]}"
    puts "#{name_batler[1]} - #{count_batler[1]}\n#{str}\n"
    count
  end

  def self.link_run(page)
    w_l = Array.new(2, 0)
    loop do
      review_links = page.links_with(text: /vs/)
      threads = []
      review_links.map do |link|
        threads << Thread.new do
          count = Kotd2.count_function(link)
          if !count.nil? && count != 2
            w_l[count] += 1
          end
        end
      end
      threads.each(&:join)
      if !page.link_with(text: /Next »/).nil?
        page = page.link_with(text: /Next »/).click
      else
        puts 'That is all'
        break
      end
    end
    if ENV['NAME']
      puts "\n#{ENV['NAME']} wins #{w_l[0]} times, loses #{w_l[1]} times"
    end
  end

  def self.start
    agent = Mechanize.new
    page = agent.get('https://genius.com/artists/King-of-the-dot')
    page = page.link_with(text: /Show all songs by King of the Dot/).click
    page
  end
end
