nokogiri = Nokogiri.HTML(content)

# Initialize an empty hash
product = {}

# Save the url
product['url'] = page['vars']['url']

# Save the ASIN
product['asin'] = page['vars']['asin']

# Extract title
product['title'] = nokogiri.at_css('#productTitle').text.strip

# Extract seller/author
seller_node = nokogiri.at_css('a#bylineInfo')
if seller_node
  product['seller'] = seller_node.text.strip.gsub("Visit the ", "")
else
  product['author'] = nokogiri.css('span.author a.a-link-normal').text.strip
  # product['author'] = nokogiri.css('a.contributorNameID').text.strip
end



# Extract number of reviews
reviews_node = nokogiri.at_css('span#acrCustomerReviewText')
reviews_count = reviews_node ? reviews_node.text.strip.split(' ').first.gsub(',','') : nil
product['reviews_count'] = reviews_count =~ /^[0-9]*$/ ? reviews_count.to_i : 0

# Extract rating
rating_node = nokogiri.at_css('#averageCustomerReviews span.a-icon-alt')
stars_num = rating_node ? rating_node.text.strip.split(' ').first : nil
product['rating'] = stars_num =~ /^[0-9.]*$/ ? stars_num.to_f : nil

# extract price
product['price'] = nokogiri.at_css('.priceToPay', '.reinventHeaderPrice', '#size_name_0_price')
if product['price'].nil? == false
  product['price'] = product['price'].text.strip.gsub(/[\$,]/,'').to_f
end

# product['price'] = nokogiri.at_css('#price_inside_buybox', '#priceblock_ourprice', '#priceblock_dealprice', '.offer-price', '#priceblock_snsprice_Based').text.strip.gsub(/[\$,]/,'').to_f

# Extract availability
availability_node = nokogiri.at_css('#availability')
if availability_node
  product['available'] = availability_node.text.strip == 'In Stock' ? true : false
else
  product['available'] = nil
end

# Extract product description
description = ''
feature_bullets = nokogiri.css('#feature-bullets li')
book_desc = nokogiri.css('#bookDescription_feature_div')

if feature_bullets.empty? == false
  p 'it has some features'
  feature_bullets.each do |li|
    # unless li['id'] || (li['class'] && li['class'] != 'showHiddenFeatureBullets')
    #   description += li.text.strip + ' '
    # end
    description += li.text.strip + "\n"
  end
elsif book_desc.empty? == false
  p 'it is a book'
  book_desc.each do |para|
    description += para.text.strip + "\n"
  end
end

product['description'] = description

#extract image
product['image'] = nokogiri.at_css('#imgTagWrapperId img')['src']

# specify the collection where this record will be stored
product['_collection'] = "products"

# save the product to the job’s outputs
outputs << product