CSV.foreach("./seeder/asins.csv", headers: true) do |row|
    url = "https://www.amazon.com/o/ASIN/#{row['ASIN']}"
    ### Example: URL ###
    # ASIN: 1476753830
    # url: "https://www.amazon.com/o/ASIN/1476753830"
    pages << {
      page_type: "products",
      method: "GET",
      headers: {"User-Agent" => "User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36 OPR/110.0.0.0"},
      url: url,
      vars: {
        url: url,
        asin: row["ASIN"]
      }
    }
  end