# Author: nakinor
# Created: 2017-03-14
# Revised: 2018-03-21

require 'yaml'
File.open("anchors.yml") do |file|
  AandC = YAML.load(file)
end

ANCHOR = `grep "@anchor{" doc/*.texi | gawk 'BEGIN {FS="@anchor{"} ; {print $2}' | sed -e 's/}$//' | sort`
CINDEX = `grep "@cindex " doc/*.texi | gawk '{print $2}' | sort`

def to_arr(data)
  tmp_arr = []
  for x in data.split("\n")
    tmp_arr << x
  end
  return tmp_arr
end

anc = to_arr(ANCHOR)
cin = to_arr(CINDEX)

AandC.each do |key, value|
  anc[anc.index(key)] = value
end

puts "anchor の数は #{anc.size} です。"
for i in anc - cin
  unless i.to_s =~ /[0-9].[0-9]/
    puts i
  end
end
puts "-------------------------"
puts "cindex の数は #{cin.size} です。"

for i in cin - anc
  unless i.to_s =~ /.txt/
    puts i
  end
end
