def length3d(p1,p2) 
	return Math.sqrt((p1[0]-p2[0])**2 + (p1[1]-p2[1])**2 + (p1[2]-p2[2])**2)
end

p = [0.17,1.68,0.11]
puts length3d(p,[-0.23,0.18,-0.05])
puts length3d(p,[0.04,-0.13,-0.27])
puts length3d(p,[-0.23,0.18,-0.05])
puts length3d(p,[-0.41,1.24,-0.65])