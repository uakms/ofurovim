# Author: nakinor
# Created: 2017-01-26
# Revised: 2019-07-16

require "optparse"
begin
  PARAMS = ARGV.getopts('', 'dir:')
rescue
  usage()
  exit
end

TAG_JA_START =
  '< @ifset JA  @c ----------- v -----------  JA'
TAG_JA_END =
  '< @end ifset @c ----------- \^ -----------  JA  ----------- \^ -----------'

def diff_docs(ifn)
  origin = "#{PARAMS['dir']}/#{File.basename(ifn).gsub(".texi", ".txt")}"
  trans = "#{ifn}"
  diff = `diff #{trans} #{origin}`
  removed_head = diff.gsub(/< \\input .* -\*-\n/, "")
  removed_ja = removed_head.gsub(/#{TAG_JA_START}.*?#{TAG_JA_END}\n/m, "")
  removed_tag = removed_ja.gsub(/< @ifset EN\n|< @end ifset\n/, "")
  removed_lan = removed_tag.gsub(/< @clear EN\n|< @clear JA\n|< @set JA\n/, "")
  judge = removed_lan.gsub(/[0-9].+d[0-9]+?\n|< \n|< @bye\n/, "")
  if judge.size == 0
    puts ifn + " --- \033[32mNot Modified.\033[0m"
  else
    puts "\033[31m" + ifn +
      " --- MODIFIED! Check the following diffs.\033[0m\n" + judge
  end
end

def usage()
  puts "Usage: #{File.basename($0)} --dir=PATH file"
end

def main()
  if PARAMS['dir'] != nil
    for x in ARGV
      diff_docs(x)
    end
  else
    usage()
  end
end

main()
