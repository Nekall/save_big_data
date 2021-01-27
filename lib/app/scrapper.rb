class Scrapper#balayage des pages
  def get_townhall_urls
    pages = Nokogiri::HTML(URI.open("http://annuaire-des-mairies.com/val-d-oise.html"))
    linkarr = []
    pages.css('.lientxt').each do |link|
      linkarr << "http://annuaire-des-mairies.com" + link["href"].delete_prefix('.')
    end
    return linkarr
  end
  #récupération des mails et des nom de villes
  def get_townhall_email(url)
    tempash = {}

    page = Nokogiri::HTML(URI.open(url))

    mail_html = page.css('table.table:nth-child(1) > tbody:nth-child(3) > tr:nth-child(4) > td:nth-child(2)').first
    mail = mail_html.text

    city_html = page.css('.col-md-12 > h1:nth-child(1)').first
    city = city_html.text.split(' - ')[0]

    tempash[city] = mail
    return tempash
  end
  #Methode d'enregistrement dans un json
  def save_as_JSON(finalist)
    File.open("db/emails.json","w") do |f|
      f.write(JSON.pretty_generate(finalist))
    end
  end
  #méthode orchestre
  def perform
    finalist = []
    get_townhall_urls.each do |link|
      finalist << get_townhall_email(link)
    end
    save_as_JSON(finalist)
    print finalist
    return finalist
  end


end
