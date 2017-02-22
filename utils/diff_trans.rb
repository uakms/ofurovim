# Author: nakinor
# Created: 2017-01-26
# Revised: 2017-02-21

TAG_JA_START =
  '> @ifset JA  @c ----------- v -----------  JA  ----------- v -----------'
TAG_JA_END =
  '> @end ifset @c ----------- \^ -----------  JA  ----------- \^ -----------'

def diff_docs(ifn)
  origin = "#{ENV['ORIG_DOC']}/#{ifn.gsub(".texi", ".txt")}"
  trans = "#{ifn}"
  diff = `diff #{origin} #{trans}`
  remove_head = diff.gsub(/0a1.*-\*-\n/m, "")
  removed_ja = remove_head.gsub(/#{TAG_JA_START}.*?#{TAG_JA_END}\n/m, "")
  removed_tag = removed_ja.gsub(/> @ifset EN\n|> @end ifset\n/, "")
  removed_lan = removed_tag.gsub(/> @clear EN\n|> @clear JA\n|> @set JA\n/, "")
  removed_fin = removed_lan.gsub(/^> @.*\n/, "")
  judge = removed_fin.gsub(/[0-9]+a[0-9].+?\n|> \n/, "")
  if judge.size == 0
    puts ifn + " --- \033[32mNot Modified.\033[0m"
  else
    puts "\033[31m" + ifn +
      " --- MODIFIED! Check the following diffs.\033[0m\n" + judge
  end
end

def usage()
  puts "Usage: #{File.basename($0)} file"
end

def main()
  if ARGV.size == 0
    usage()
  elsif ENV['ORIG_DOC'] == nil
    puts "環境変数 ORIG_DOC を指定してや"
  else
    for x in ARGV
      diff_docs(x)
    end
  end
end

main()
