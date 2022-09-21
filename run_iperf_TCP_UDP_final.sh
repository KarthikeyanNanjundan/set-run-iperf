#!/bin/bash
sysfs_path="/sys/class/mmc_host/mmc1/device"

ip="192.168.1.179"
time="10"

run=$(($time * 2))

sudo ufw disable
sleep 1
echo "Ubuntu Firewall Disabled"
echo "Running iperf"


gnome-terminal --tab --command="sh -c 'sudo adb shell iperf -s -i1 | tee tcp.txt && exit; $SHELL'"
sleep 1
gnome-terminal --tab --command="sh -c 'sudo iperf -c $ip -i1 -t $time -r && exit; $SHELL'"
sleep $run
sleep 1
echo " TCP Rx & Tx = "
cat tcp.txt | grep 0.0-$time -ni
echo "---------------------------------------------
"

gnome-terminal --tab --command="sh -c 'sudo adb shell iperf -s -i1 -u | tee udp.txt && exit; $SHELL'"
sleep 1
gnome-terminal --tab --command="sh -c 'sudo iperf -c $ip -i1 -t $time -b 200m -u -r && exit; $SHELL'"
sleep $run
sleep 1
echo " UDP Rx & Tx = "
cat udp.txt | grep 0.0-$time -ni
echo "---------------------------------------------
"

echo "Press ENTER to run iperf or q to close all terminals"

while [ 1 -eq 1 ]
do
read  input
	if [ "$input" = "" ]; then
                sudo ./run_iperf_TCP_UDP_final.sh

        elif [ "$input" = "q" ]; then
                echo "Closing all terminals"
                sleep 1
		sudo kill `ps -e | grep -i gnome-terminal | cut -f 1 -d " "`
		exit
	fi
done
