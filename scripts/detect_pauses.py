#!/usr/bin/python

from optparse import OptionParser
import fileinput
import time

def printable_time(seconds_from_epoch):
    return time.strftime('%H:%M:%S', time.strptime(time.ctime(seconds_from_epoch)))


usage = "Usage: %prog [options] [log_file]"
parser = OptionParser(usage=usage)
parser.add_option("-p", "--pause-limit", action="store", type="float",
                    dest="pause_limit", default=1.0,
                    help="Detection limit for pauses in seconds. Will detect any pauses >= the pause-limit. Defaults to 1 second")

(options, file_names) = parser.parse_args();

max_delay = options.pause_limit
start_time = 0
last_time = 0
last_time_stamp = None

delay_count = 0;
total_delay_time = 0.0;
max_observed_delay = 0.0;

print "Running on file %(file_names)s" % locals()

for line in fileinput.input(file_names):
    columns = line.split(" ")
    if len(columns) == 36:
        current_time = float(columns[2])/1000
        current_time_stamp = printable_time(current_time)
        if last_time == 0:
            print "Started At %(current_time_stamp)s" % locals()
            start_time = current_time
        else:
            last_time_stamp = printable_time(last_time)
            delay = current_time - last_time
            if delay > max_observed_delay:
                max_observed_delay = delay
            if delay >= max_delay:
                print "Detected Pause from %(last_time_stamp)s to %(current_time_stamp)s (delta: %(delay)0.3f)" % locals()
                delay_count += 1
                total_delay_time += delay

        last_time = current_time

print "Ended at %(last_time_stamp)s" % locals()
total_elapsed_time = last_time - start_time
total_elapsed_time_str = time.strftime('%H:%M:%S',time.gmtime(total_elapsed_time))
print "Total Elapsed Time: %(total_elapsed_time_str)s" % locals()
print "Max Observed Delay: %(max_observed_delay)s" % locals()
print "Number of Delays >= %(max_delay)s seconds: %(delay_count)s" % locals()
print "Total Delay Time: %(total_delay_time)s" % locals()
