# Author: nakinor
# Created: 2018-03-27
# Revised: 2018-04-03

class VDJCheck

  # *.texi ファイル中の @ifset JA ... @end ifset の部分を抜き出して、
  # さらに @verbatim ... @end verbatim の範囲を除外して、
  # さらに @example ... @end example の範囲を除外したものを、
  # @buffer として配列に保存する。
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

  # || ではさまれた単語を抽出する
  # リンクを意味する単語の目印として使われている
  # ここでは扱っていないが、被リンクは ** ではさまれている
  def check_bar()
    @buffer.each do |line|
      # line.scan(/\|[[:ascii:]].*?\|/).each do |x|
      line.scan(/\|[\x21-\x7b\x7d-\x7e].*?\|/).each do |x|
        unless (x =~ /@ref{/) || (x=~ /[\u0080-\uffff]/) || (x =~ /b\\/)
          puts x.gsub("|","")
        end
      end
    end
  end

  # '' ではさまれた単語を抽出する
  # オプションもしくはコマンド意味する単語の目印として使われている
  def check_quote()
    @buffer.each do |line|
      line.scan(/'[\x21-\x7b\x7d-\x7e].*?'/).each do |x|
        unless (x =~ /@command{/) || (x =~ /@option{/) || (x=~ /[\u0080-\uffff]/) || (x =~ / /)
          puts x.gsub("'","")
        end
      end
    end
  end

  # "" ではさまれた単語を抽出する
  # 変数を意味する単語の目印として使われている
  def check_double_quote()
    @buffer.each do |line|
      line.scan(/"[\x21-\x7b\x7d-\x7e].*?"/).each do |x|
        unless (x =~ /@var{/) || (x =~ /@env{/) || (x=~ /[\u0080-\uffff]/) || (x =~ / /)
          puts x.gsub("\"","")
        end
      end
    end
  end

  # `` ではさまれた単語を抽出する
  # コマンドを意味する単語の目印として使われている
  # 最近使いはじめられたが統一する意志はないようだ
  def check_back_quote()
    @buffer.each do |line|
      line.scan(/`[\x21-\x7b\x7d-\x7e].*?`/).each do |x|
        unless (x =~ /@command{/) || (x=~ /[\u0080-\uffff]/) || (x =~ / /)
          puts x.gsub("`","")
        end
      end
    end
  end

  def check_tags(flag)
    tmp_anchor_arr = []
    tmp_xindex_arr = []
    @buffer.each do |line|
      line.scan(/@anchor{.*?}\n/).each do |x|
        x =~ /@anchor{(.*)?}\n/
        tmp_anchor_arr << $1
      end
      line.scan(/@[cfkptv]index .*?\n/).each do |x|
        x =~ /@[cfkptv]index (.*)?\n/
        tmp_xindex_arr << $1
      end
    end
    if flag == true
      puts "anchor: #{tmp_anchor_arr.size}"
      puts "xindex: #{tmp_xindex_arr.size}"
    end
    return [tmp_anchor_arr, tmp_xindex_arr]
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
  when "--backquote"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      VDJCheck.new(f).check_back_quote
    end
  when "--tags"
    term_arr = []
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      term_arr << VDJCheck.new(f).check_tags(true)
    end
    puts "-------"
    sum_arr = []
    for x in term_arr
      sum_arr << [x[0].size, x[1].size]
    end
    puts sum_arr.transpose.map {|x| x.inject(:+)}
  when "--show-anchors"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      puts VDJCheck.new(f).check_tags(false)[0]
    end
  when "--show-indexes"
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      puts VDJCheck.new(f).check_tags(false)[1]
    end
  when "--diff"
    anchor_xindex = {}
    require 'yaml'
    File.open("anchors.yml") do |file|
      anchor_xindex = YAML.load(file)
    end
    for f in ARGV.drop(1)
      puts "\033[32m" + f.split('/').last + "\033[0m:"
      tmp_arr = VDJCheck.new(f).check_tags(false)
      only_anchor = tmp_arr[0] - tmp_arr[1]
      only_xindex = tmp_arr[1] - tmp_arr[0]
      # puts "anchor の数は #{only_anchor.size} です。"
      for x in only_anchor
        unless anchor_xindex.has_key?(x)
          puts x
        end
      end
      # puts "xindex の数は #{only_cindex.size} です。"
      for x in only_xindex
        unless anchor_xindex.has_value?(x)
          puts x
        end
      end
    end
  else
    puts "#{File.basename($0)} [options] file..."
    puts " --bar:          バーティカルバーではさまれた単語を抽出"
    puts " --quote:        シングルクォートではさまれた単語を抽出"
    puts " --doublequote:  ダブルクォートではさまれた単語を抽出"
    puts " --backquote:    バッククォートではさまれた単語を抽出"
    puts " --tags:         anchor と cindex の数を抽出"
    puts " --diff:         anchor と cindex の差分を抽出"
    puts " --show-anchors: anchor を表示する"
    puts " --show-indexes: index を表示する"
  end
end

if __FILE__ == $0
  main()
end
