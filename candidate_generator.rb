class CandidateGenerator
  require 'nokogiri'
  require 'open-uri'
  require 'romaji'
  require "romaji/core_ext/string"
  require 'csv'

  URL = 'http://www.hajime.halfmoon.jp/4moji.htm'

  def initialize(filename)
    @filename = filename
  end

  def run
    charset = "utf-8"

    html = open(URL).read

    doc = Nokogiri::HTML.parse(html, nil, charset)

    CSV.open(@filename, "w") do |csv|
      doc.xpath('//td').each_with_index do |node, i|
        if check(node.inner_html) then
          # ローマ字に変換した4文字熟語をcsvに書き込む
          csv << [doc.xpath('//td')[i + 1].inner_html.romaji]
        end
      end
    end
  end

  private

  # 4文字熟語であるかの判定
  def check(str)
    return false if str.length != 4

    str.lines do |s|
      return false if !(s =~ /[一-龠々]/)
    end

    return true
  end
end