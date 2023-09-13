
# deploy to VM 05.01.2022
import argparse
import time
import multiprocessing as mp
import queue
from datetime import datetime

from mqtt_to_file import main


def watchdog(q, WATCHDOG_TIMEOUT):
    """
    This check the queue for updates and send a signal to it
    when the child process isn't sending anything for too long
    """
    while True:
        try:
            msg = q.get(timeout=WATCHDOG_TIMEOUT)
        except queue.Empty as e:
            q.put("KILL WORKER")

# Read arguments from command line

if __name__ == '__main__':
    
    while True:
        q = mp.Queue()

        workr = mp.Process(target=main, args=(q,))
        wdog = mp.Process(target=watchdog, args=(q,1800))

        # run the watchdog as daemon so it terminates with the main process
        #wdog.daemon = True

        workr.start()
        wdog.start()

        # Poll the queue
        while True:
            msg = q.get()
            if msg == "KILL WORKER":

                workr.terminate()
                wdog.terminate()
                time.sleep(0.1)
                if not workr.is_alive():
                    workr.join(timeout=1.0)
                    wdog.join(timeout=1.0)
                    q.close()
                    break # watchdog process daemon gets terminated
        