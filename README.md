# Cluster Mining for Raspberry Pi's
This is a school project and a proof of concept for mining on a raspberry pi cluster

## Used stack
* XMRig for Mining
* MPICH to use the Message Passing Interface (MPI) standard
* Docker to quickly ramp up containers/miners

## Todo's
If a new worker is created within the docker-compose, said worker is not yet attached to the cluster automatically. This step has to be done manually on the Master-Node with the command:
```bash
mpiexec ...
```

## Notes
This is only a quick and dirty proof of concept and does not fully implement any aspect.
