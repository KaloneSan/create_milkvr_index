#!/usr/bin/ruby

# file format for milkvr = 
# milkvr://sideload/?url=http%3A%2F%2F10.10.10.10:8080%2Fvideofilename_3dh.mp4&video_type=3dh

working_dir = "./"
host = "localhost"
port = "80"
# default type horizontal
video_type = "3dh"

def filter_vtype(filename) 
	video_types = {
	"2D video" => "_2dp",
	"3D top bottom video" => "_3dpv",
	"3D side by side video" => "_3dph",
	"Monoscopic 180" => "180x180",
	"Monoscopic 180 16:9" => "180x101",
	"Monoscopic 360" => "_mono360",
	"Top bottom stereoscopic 360" => "3dv",
	"Top bottom stereoscopic 360 2" => "_tb",
	"Left right stereoscopic 360" => "3dh",
	"Left right stereoscopic 360 2" => "_lr",
	"Top bottom stereoscopic 3D 180" => "180x180_3dv",
	"Left right stereoscopic 3D 180" => "180x180_3dh",
	"LR stereo 3D 180 squished" => "180x180_squished_3dh",
	"Top bottom stereoscopic 3D 180x160" => "180x160_3dv",
	"Two monoscopic 180 hemispheres" => "180hemispheres",
	"TB 3D cylinder 2.25:1" => "cylinder_slice_2x25_3dv",
	"TB 3D cylinder 16:9" => "cylinder_slice_16x9_3dv",
	"TB 3D 360 no bottom" => "sib3d",
	"180 planetarium full dome" => "_planetarium",
	"180 planetarium full dome 2" =>  "_fulldome",
	"V360 camera" => "_v360",
	"RTXP 360 cylindrical" => "_rtxp"
	}
	
	# some types overlap, so always choose the longest (most specific) match
	match = ""
	video_types.each do |key, val|
		/#{val}/.match(filename) and match = val if match.length < val.length
	end
	return match
end

links = []

index = open("index.html", 'w')
index.write("<HTML\n>")
index.write("<HEAD><TITLE>My Sideload Videos</TITLE></HEAD>\n")
index.write("<BODY>\n")
Dir.chdir(working_dir)
Dir.glob("*.{mp4,mkv}") do |filename|
	#/(3d[h,v])/.match(filename) and video_type=$1
	video_type = filter_vtype(filename)
	link = "milkvr://sideload/?url=http%3A%2F%2F#{host}:#{port}%2F#{filename}&video_type=#{video_type}"
	index.write("<P><A HREF=#{link}>#{filename}</A></P>\n") 
end
index.write"</BODY>\n"
index.write"</HTML>\n"
