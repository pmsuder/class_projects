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


```
slurmInfo epi

----------------------------------------------------------------------
Allocation summary:    Time Limit             Hardware Resources
   Investment QOS           Hours          CPU     MEM(GB)     GPU
----------------------------------------------------------------------
              epi             744          500        1757       0
----------------------------------------------------------------------
CPU/MEM Usage:              Running          Pending        Total
                          CPU  MEM(GB)    CPU  MEM(GB)    CPU  MEM(GB)
----------------------------------------------------------------------
        Investment (epi):    75      686    17      947    92     1633
----------------------------------------------------------------------
HiPerGator Utilization
               CPU: Used (%) / Total         MEM(GB): Used (%) / Total
----------------------------------------------------------------------
        Total :  36236 (76%) / 47320     108153896 (54%) /   198437000
----------------------------------------------------------------------
* Burst QOS uses idle cores at low priority with a 4-day time limit
```

```
slurmInfo plantpath
```
> ----------------------------------------------------------------------
> Allocation summary:    Time Limit             Hardware Resources
>   Investment QOS           Hours          CPU     MEM(GB)     GPU
> ----------------------------------------------------------------------
>        plantpath             744           75         263       4
> ----------------------------------------------------------------------
> CPU/MEM Usage:              Running          Pending        Total
>                          CPU  MEM(GB)    CPU  MEM(GB)    CPU  MEM(GB)
> ----------------------------------------------------------------------
> Investment (plantpath):    12       64     0        0    12       64
>     Burst* (plantpath-b):     4       10     0        0     4       10
> ----------------------------------------------------------------------
> HiPerGator Utilization
>               CPU: Used (%) / Total         MEM(GB): Used (%) / Total
> ----------------------------------------------------------------------
>        Total :  36191 (76%) / 47320     108024856 (54%) /   198437000
> ----------------------------------------------------------------------
> * Burst QOS uses idle cores at low priority with a 4-day time limit
