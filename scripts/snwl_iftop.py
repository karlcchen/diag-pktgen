#!/usr/bin/python
import time, sys, os

def get_bytes(t, iface='eth0'):
	with open('/sys/class/net/' + iface + '/statistics/' + t + '_bytes', 'r') as f:
		data = f.read();
		return int(data)

def check_tx_rx_bytes( max_loop=10 ):

    loop = 0 
    error = 0 
    while ( loop < max_loop ):
        tx1 = get_bytes('tx')
        rx1 = get_bytes('rx')

        time.sleep(1)

        tx2 = get_bytes('tx')
        rx2 = get_bytes('rx')

        tx_bytes = tx2 - tx1 
        rx_bytes = rx2 - rx1 

        tx_speed = round((tx_bytes)/1000000.0, 4)
        rx_speed = round((rx_bytes)/1000000.0, 4)

        print("%d, TX: %fMbps  RX: %fMbps") % (loop, tx_speed*8, rx_speed*8)

        if ( tx_bytes != rx_bytes ): 
            print( "%d, Warning: Mismacthed TX_Bytes:%d: RX_bytes:%d, Difference:%d bytes") % (loop, tx_bytes, rx_bytes, tx_bytes - rx_bytes ) 
            error = error + 1
        loop = loop + 1
    return( error )

error_cnt = check_tx_rx_bytes(10)
sys.exit( error_cnt )

