require 'rubygems'
require 'faster_csv'
 
 FasterCSV.foreach("/Users/russell/dev/scratch/data1.csv", :quote_char => '"', :col_sep =>',', :row_sep =>:auto) do |row|
   puts "#{row[0].strip}<br/>" if row[0]
   puts "#{row[1].strip}<br/>" if row[1] 
   puts "#{row[2].strip}<br/>" if row[2] 
   puts "#{row[3].strip}, #{row[4]} #{row[5]}<br/>"  if row[3] 
   puts
 end