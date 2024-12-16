import ray
from ray.util.spark import setup_ray_cluster, shutdown_ray_cluster

### Check if Ray is initialized
if ray.is_initialized():
    shutdown_ray_cluster()
    ray.shutdown()
    print("Ray cluster has been shut down.")
else:
    print("Ray cluster is not running.")

### Set up Ray cluster on Spark
ray_cluster_handle, ray_address = setup_ray_cluster(
    max_worker_nodes=1,
    min_worker_nodes=1,
    num_cpus_per_node=4,
    num_gpus_worker_node=0,
    collect_log_to_path="/dbfs/path/to/ray_collected_logs",
    )

### Initialize Ray with the address provided by the cluster handle
ray.init(address=ray_address)

### Define a remote function to run in parallel
@ray.remote
def square(x):
    return x * x

### Execute the remote function across the Ray cluster
futures = [square.remote(i) for i in range(10)]

### Collect the results from all remote executions
results = ray.get(futures)

print("Square results:", results)
