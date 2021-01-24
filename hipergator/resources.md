## Hipergator account

Commands to get the resources of the @garrettlab

```
showAssoc ralcala
# User              Account       Def Acct        Def QOS        QOS
#------------------ -------------- -------------- -------------- ----------------------------------------
#ralcala            plantpath      garrett        garrett        plantpath,plantpath-b
#ralcala            garrett        garrett        garrett        garrett,garrett-b
#ralcala            epi            garrett        garrett        epi,epi-b,garrett
```

```
showQos garrett
# Name                          Descr                                       GrpTRES                 GrpCPUs
#-------------------- ------------------------------ --------------------------------------------- --------
#garrett              garrett qos                    cpu=10,gres/gpu=0,mem=36000M                        10
showQos garrett-b
# Name                          Descr                                       GrpTRES                 GrpCPUs
#-------------------- ------------------------------ --------------------------------------------- --------
#garrett-b            garrett burst qos              cpu=90,gres/gpu=0,mem=324000M                       90
```

Additional base priority run time and limits associated to garret QOSes
```
sacctmgr show qos format="name%-20,Description%-30,priority,maxwall" garrett
# Name                          Descr   Priority     MaxWall
#-------------------- ------------------------------ ---------- -----------
#garrett              garrett qos                         36000 31-00:00:00
```
