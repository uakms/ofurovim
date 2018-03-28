# Author: nakinor
# Created: 2018-03-27
# Revised: 2018-03-28

def check_jatag(file)
  puts "\033[32m" + file.split('/').last + "\033[0m:"
  buf_list_a = []
  buf_list_b = []
  File.open(file, "r").each do |line|
    next unless line =~ /@ifset JA  @c/ .. line =~ /@end ifset @c/
    buf_list_a << line
  end
  buf_list_a.each do |line|
    next if line =~ /@verbatim/ .. line =~ /@end verbatim/
    buf_list_b << line
  end
  buf_list_b.each do |line|
    next if line =~ /@example/ .. line =~ /@end example/
    check_anchor(line)
  end
end

def check_anchor(line)
  line.scan(/\|[x21-x7b|x7d-x7e].*?\|/).each do |x|
  # line.scan(/\|[x21-x7e].*?\|/).each do |x|
  # line.scan(/\|[[:ascii:]].*?\|/).each do |x|
    unless (x =~ /@ref{/) || (x=~ /[\u0080-\uffff]/) || (x =~ /b\\/)
      puts x.gsub("|","")
    end
  end
end

def main()
  for f in ARGV
    check_jatag(f)
  end
end

if __FILE__ == $0
  main()
end
