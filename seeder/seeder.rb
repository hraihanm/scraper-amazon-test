CSV.foreach("./seeder/asins.csv", headers: true) do |row|
    url = "https://www.amazon.com/o/ASIN/#{row['ASIN']}"
    pages << {
      page_type: "products",
      method: "GET",
      headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.98 Safari/537.36"},
      url: url,
      vars: {
        url: url,
        asin: row["ASIN"]
      }
    }
  end