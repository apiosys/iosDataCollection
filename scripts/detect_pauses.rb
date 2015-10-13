#!/usr/bin/ruby

require "optparse"

max_delay = 1.0

OptionParser.new do |opts|
	opts.banner = "Usage: #{__FILE__} [options] log_file"

	opts.on("--pause-limit N", Float, "Detection limit for pauses in seconds. Will detect any pauses >= the pause-limit. Defaults to 1 second") do |v|
		max_delay = v
	end

end.parse!

start_time = 0
last_time = 0
last_time_stamp = nil

delay_count = 0;
total_delay_time = 0.0;

ARGF.read.split("\n").each do |line|
	columns = line.split(" ")
	if columns.count == 36
		current_time = columns[2].to_f/1000
		current_time_stamp = Time.at(current_time).strftime('%H:%M:%S.%L')
		if last_time == 0
			puts "Started At #{current_time_stamp}"
			start_time = current_time
		else
			last_time_stamp = Time.at(last_time).strftime('%H:%M:%S.%L')
			delay = current_time - last_time
			if delay >= max_delay
				puts "Detected Pause from #{last_time_stamp} to #{current_time_stamp} (delta: #{delay.round(3)})" if delay >= max_delay
				delay_count += 1
				total_delay_time += delay
			end
		end

		last_time = current_time
	end
end

puts "Ended at #{last_time_stamp}"
total_elapsed_time = last_time - start_time
puts "Total Elapsed Time: #{Time.at(total_elapsed_time).utc.strftime("%H:%M:%S")}"
puts "Number of Delays >= #{max_delay} seconds: #{delay_count}"
puts "Total Delay Time: #{total_delay_time}"
