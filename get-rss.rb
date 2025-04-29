require "json"
require "open-uri"
require "fileutils"

Address = "localhost"

def get_users
  File.open("users.json", "r") do |f|
    JSON.load(f)
  end
end

def download(url, path)
  FileUtils.mkdir_p(File.dirname(path))
  URI.open(url) do |uri|
    File.open(path, "wb") do |f|
      IO.copy_stream(uri, f)
    end
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
    download("http://#{Address}/#{item}/rss", "dist/#{item}")
    usersText << "## [#{item}](./#{item})\n"
  end

  saveREADME("dist/README.md", usersText)
end
