# Author: nakinor
# Created: 2018-03-27
# Revised: 2018-03-29

class VDJCheck
  def initialize(file)
    @buffer = []
    tmp_list_a = []
    tmp_list_b = []
    File.open(file, "r").each do |line|
      next unless line =~ /@ifset JA  @c/ .. line =~ /@end ifset @c/
      tmp_list_a << line
    end
    tmp_list_a.each do |line|
      next if line =~ /@verbatim/ .. line =~ /@end verbatim/
      tmp_list_b << line
    end
    tmp_list_b.each do |line|
      next if line =~ /@example/ .. line =~ /@end example/
      @buffer << line
    end
  end

  def check_bar()
    @buffer.each do |line|
      line.scan(/\|[x21-x7b|x7d-x7e].*?\|/).each do |x|
        # line.scan(/\|[x21-x7e].*?\|/).each do |x|
        # line.scan(/\|[[:ascii:]].*?\|/).each do |x|
        unless (x =~ /@ref{/) || (x=~ /[\u0080-\uffff]/) || (x =~ /b\\/)
          puts x.gsub("|","")
        end
      end
    end
  end

  def check_quote()
    @buffer.each do |line|
      line.scan(/'[x21-x7b|x7d-x7e].*?'/).each do |x|
        unless (x =~ /@command{/) || (x =~ /@option{/) || (x=~ /[\u0080-\uffff]/)
          puts x.gsub("'","")
        end
      end
    end
  end

  def check_double_quote()
    @buffer.each do |line|
      line.scan(/"[x21-x7b|x7d-x7e].*?"/).each do |x|
        unless (x =~ /@var{/) || (x =~ /@env{/) || (x=~ /[\u0080-\uffff]/)
          puts x.gsub("'","")
        end
      end
    end
  end

  def check_tags()
    tmp_anchor_arr = []
    tmp_cindex_arr = []
    @buffer.each do |line|
      line.scan(/@anchor{.*?}\n/).each do |x|
        tmp_anchor_arr << x
      end
      line.scan(/@cindex .*?\n/).each do |x|
        tmp_cindex_arr << x
      end
    end
    puts "anchor: #{tmp_anchor_arr.size}"
    puts "cindex: #{tmp_cindex_arr.size}"
    return [tmp_anchor_arr.size, tmp_cindex_arr.size]
  end

  def print_buf()
    puts @buffer
  end
end

def main()
  case ARGV[0]
  when "--bar"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      VDJCheck.new(f).check_bar
    end
  when "--quote"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      VDJCheck.new(f).check_quote
    end
  when "--doublequote"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      VDJCheck.new(f).check_double_quote
    end
  when "--tags"
    sum_arr = []
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      sum_arr << VDJCheck.new(f).check_tags
    end
    puts "-------"
    puts sum_arr.transpose.map {|x| x.inject(:+)}
  else
    puts "#{File.basename($0)} [options] file..."
    puts " --bar:         バーティカルバーではさまれた単語を抽出"
    puts " --quote:       シングルクォートではさまれた単語を抽出"
    puts " --doublequote: ダブルクォートではさまれた単語を抽出"
    puts " --tags:        anchor と cindex を抽出"
  end
end

if __FILE__ == $0
  main()
end
