require 'csv'
require 'pp'

qty = 30

puts "Type number of clustering"
cluster = gets.chop.to_i

random = Random.new
ary = Array.new

for i in 1..qty do
 ary.push(random.rand(1..cluster))
end

CSV.open("initialize"+cluster.to_s+".csv","wb") do |csv|
 csv << ary
end

pp ary