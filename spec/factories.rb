require 'factory_girl'

Factory.define :category do |f|
  f.name   'Page One'
end

Factory.define :feed do |f|
  f.name        'Page One'
  f.url         'http://online.wsj.com/page/us_in_todays_paper.html'
  f.association :category, :factory => :category
end

Factory.define :rss_feed do |f|
  f.name        'Whats News'
  f.url         'http://online.wsj.com/xml/rss/3_7011.xml'
  f.association :category, :factory => :category
end

Factory.define :article do |a|
  a.title       'Baccarat Meets Bomb-Proof Glass'
  a.subtitle    'A Russian billionaire\'s $300 million, Philippe Starck-designed yacht makes waves'
  a.url         'http://online.wsj.com/article/SB10001424052702303695604575181911796253780.html'   
  a.author      'By Robert Frank'
  a.pub_date    'APRIL 15, 2010'
  a.fulltext    "<p>BARBADOS At the top of a spiral staircase lined with scalloped, silver-leaf walls (the banister cost $60,000) is a door accessible by a fingerprint security system. It opens to an all-white, 2,583-square-foot master suite wrapped in bomb-proof, 44-milimeter glass. There, a king-sized bed sits on a giant platter that rotates with the press of a silver button. Another set of buttons rotates the bed itself. The combination of the rotating bed and the rotating platter allows limitless angles for watching the sunset, sunrise or the 60-inch plasma TV, which retracts from the ceiling.</p>"
  a.description 'BARBADOS-At the top of a spiral staircase lined with scalloped, silver-leaf walls (the banister cost $60,000) is a door accessible by a fingerprint security system. It opens to an all-white, 2,583-square-foot master suite wrapped in bomb-proof, 44-milimeter glass. There, a king-sized bed sits on a giant platter that rotates with the press of a silver button. Another set of buttons rotates the bed itself. The combination of the rotating bed and the rotating platter allows limitless angles for watching the sunset, sunrise or the 60-inch plasma TV, which retracts from the ceiling.'
  a.priority     1
  a.active       1
  a.unread       1
  a.attempts     0
  a.association  :feed, :factory => :feed
  a.association  :category, :factory => :category
end

Factory.define :article_with_image, :parent => :article do |a|
  a.association :image, :factory => :image
end

Factory.define :image do |i|
  i.association :article, :factory => :article
  i.url         'http://si.wsj.net/public/resources/images/OB-IB953_geithn_D_20100408062717.jpg'
  i.caption     'An employee bundles yuan banknotes at a bank in Changzhi, in China\'s Shanxi province April 8, 2010.'
  i.active       1
end

