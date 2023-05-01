import concurrent.futures
import queue
import threading
import subprocess

class WorkerPool:
    def __init__(self, worker_count, external_commands):
        self.worker_count = worker_count
        self.external_commands = external_commands
        self.task_queue = queue.Queue()

        for cmd in external_commands:
            self.task_queue.put(cmd)

        self.executor = concurrent.futures.ThreadPoolExecutor(max_workers=worker_count)
        self.futures = []

        for _ in range(worker_count):
            future = self.executor.submit(self.worker)
            self.futures.append(future)

    def worker(self):
        while not self.task_queue.empty():
            try:
                cmd = self.task_queue.get_nowait()
                print(f"Executing command: {cmd}")
                
                # Execute the command and process the result
                result = subprocess.run(cmd, shell=True, text=True, capture_output=True)

                if result.returncode == 0:
                    print(f"Command '{cmd}' executed successfully:\n{result.stdout}")
                else:
                    print(f"Command '{cmd}' failed:\n{result.stderr}")
            except queue.Empty:
                break

    def join(self):
        concurrent.futures.wait(self.futures)
        self.executor.shutdown()

# # Example usage:
# if __name__ == "__main__":
#     external_commands = ["echo 'Hello, World!'", "sleep 2; echo done", "pwd"]
#     worker_pool = WorkerPool(worker_count=3, external_commands=external_commands)
#     worker_pool.join()
