# Nomad cluster in one region and two datacenters  

### High-level overview
<img src="diagrams/nginx-reverse-proxy-nomad-1-region-2-dcs.png" />

### Pre-requisites

- vagrant
- virtualbox
- git

## How to run

##### Get the repo and bring up the environment

```
git clone https://github.com/achuchulev/nomad-vagrant-1_region-2_dc.git
cd nomad-vagrant-1_region-2_dc
vagrant up
```

### Access nomad

#### via UI

- Click [here](http://192.168.10.250) to access Nomad UI

#### via CLI

ssh to any server or client virtualbox vm

```
vagrant ssh <box_name>
```

### Run nomad job

#### via UI

- go to [jobs](http://192.168.10.250/ui/jobs)
- click on `Run job`
- paste or author HCL or JSON to submit to your cluster. A plan will be requested before the job is submitted
- run `Plan`
- review `Job Plan` and `Run` it


#### via CLI

```
nomad job run [options] <job file>
```
