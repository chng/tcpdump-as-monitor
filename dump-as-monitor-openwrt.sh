iwconfig wlan0 mode monitor
ifconfig wlan0 up

chans2="1 2 3 4 5 6 7 8 9 10 11"
chans5="36 40 44 48 52 56 60 64 100 104 108 112 116 120 124 128 132 136 140 149 153 157 161 165"
time_per_chan=2

echo $chans2
echo $chans5

while [ "1" = "1" ]
do
        echo starty
        for chan in $chans2
        do
                iwconfig wlan0 channel $chan
                # timeout tcpdump -e -s 0 -i wlan0 2> /dev/null
                ( tcpdump -e -s 0 -i wlan0 2> /dev/null ) & pid=$!
                ( sleep $time_per_chan && kill -HUP $pid ) 2> /dev/null & watchdog=$!
                if wait $pid 2> /dev/null; then
                        kill -HUP -P $watchdog
                        wait $watchdog
                fi
        done

        for chan in $chans5
        do
                iwconfig wlan0 channel $chan
                # timeout tcpdump -e -s 0 -i wlan0 2> /dev/null
                ( tcpdump -e -s 0 -i wlan0 2> /dev/null ) & pid=$!
                ( sleep $time_per_chan && kill -HUP $pid ) 2> /dev/null &watchdog=$!
                if wait $pid 2> /dev/null; then
                        kill -HUP -P $watchdog
                        wait $watchdog
                fi
        done
done
