require 'csv'
require 'pp'

def length3d(p1,p2) 
	return Math.sqrt((p1[0]-p2[0])**2 + (p1[1]-p2[1])**2 + (p1[2]-p2[2])**2)
end

def get3dPoint(object)
	return [object[:gdp],object[:density],object[:birth]]
end


data = Array.new()


#import data from csv
qty = 0
CSV.foreach("oecd.csv") do |row|   
  data.push(Hash[ :name => row[0], :gdp => row[1].to_f , :density => row[2].to_f, :birth => row[3].to_f])	
  qty += 1
 end


#first categorize 
#random = Random.new
#data.each do |a|
#  a.store(:class,random.rand(1..4))
#end


#import initial clustering data from csv
CSV.foreach("initialize4.csv") do |row|
   if row.length != qty then
   		puts "initialize.csv invaild initialize file."
   		exit
   end
   counter = 0 
   row.each do |cls|
   		data[counter].store(:class,cls.to_i)
   		counter+=1
   	end
end


pp data

cluster = Hash.new
cluster_before = 0

counter = 1
while cluster_before != cluster do
	puts "\nTrying Step: " + counter.to_s + "\n"
	cluster_before = cluster.clone

	#calucurate center of glavity for each cluster 
	for num in 1..4 do

		if !cluster.has_key?(:gdp) then
			cluster.store(num,Hash[:gdp => 0, :density=> 0, :birth => 0, :qty => 0])
		end

		#Caluculate each center of glavity 
		data.each do |a|
			if a[:class] == num then
				for factor in [:gdp,:density,:birth] do
					cluster[num][factor] += a[factor]
				end
				cluster[num][:qty]+=1
				#print cluster[num][:qty]
			end
		end

		for factor in [:gdp,:density,:birth] do
				cluster[num][factor] /= cluster[num][:qty]
		end

	end

	#re-categorize 
	data.each do |a| 
		length = 100
		for num in 1..4 do
			if length >= length3d(get3dPoint(a),get3dPoint(cluster[num])) then
				a[:class] = num
				length = length3d(get3dPoint(a),get3dPoint(cluster[num]))
			end
		end
	end

	pp cluster
	#pp cluster_before

	puts "Waiting for user. Enter to next step. Type \"l\" to List detail of the clusters"
	if gets.chop == "l" then
		 pp data
	end
	counter += 1
end


puts "All steps:"+(counter-1).to_s+". K-means method converged. "


File.open("plotdata.dat","w") do |file|
	for num in 1..4 do
		file.write("# cluster:"+ num.to_s() +"\n")
		data.each do |a|
			if a[:class] == num then
				puts file << get3dPoint(a).join("\t")+"\n"
			end
		end
		puts file << "\n\n"
	end
end

