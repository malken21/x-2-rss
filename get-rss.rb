require "json"
require "open-uri"
require "fileutils"

Address = "localhost"

def get_users
  File.open("users.json", "r") do |f|
    JSON.load(f)
  end
end

def replace_http_with_https(text)
  text.gsub("http://", "https://")
end

def download(url, path)
  FileUtils.mkdir_p(File.dirname(path))
  content = URI.open(url).read
  replaced_content = replace_http_with_https(content)
  File.open(path, "w") do |local_file|
    local_file.write(replaced_content)
  end
end

def saveREADME(path, text)
  File.open(path, "w") do |file|
    file.puts(text)
  end
end

if __FILE__ == $0
  usersText = ""

  get_users.each do |item|
    download("http://#{Address}/#{item}/rss", "dist/#{item}.rss")
    usersText << "## [#{item}](./#{item}.rss)\n"
  end

  saveREADME("dist/README.md", usersText)
end
