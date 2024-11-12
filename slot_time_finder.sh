#!/bin/bash
# Get the start and end time based on the time slot.
# usage $ ./script [N SLOT AGO]

SLOT_MINS=15  #Per slot duration


n_slot_ago=$1;
n_slot_ago=$((n_slot_ago * SLOT_MINS))

# Start time rounded down to the nearest 15-minute interval   
start_time_utc=$(date -u +"%Y-%m-%d %H:%M:%S" -d "$n_slot_ago mins ago")
minute=$(date -u -d"$start_time_utc UTC" +"%M" )
minute=$((minute - (minute % SLOT_MINS)))  ;  [[ "$minute" -lt 10 ]] && minute="0$minute"
start_time_utc=$(date -u +"%Y-%m-%d %H:$minute:00")

# +15 minutes to start time
#for current slot use current time as end time

if [[ "$n_slot_ago" -gt "0" ]];then
	end_time_utc=$(date -d "$start_time_utc UTC + $((SLOT_MINS )) minutes" +"%Y-%m-%d %H:%M:%S")
else
	end_time_utc=$(date -u +"%Y-%m-%d %H:%M:%S")
fi

# Convert UTC to EST
start_time_est=$(TZ="America/New_York" date -d "$start_time_utc UTC" +"%Y-%m-%d %H:%M:%S")
end_time_est=$(TZ="America/New_York" date -d "$end_time_utc UTC" +"%Y-%m-%d %H:%M:%S")

echo -e "(UTC): '$start_time_utc' '$end_time_utc'"
echo -e "(EST): '$start_time_est' '$end_time_est'"
