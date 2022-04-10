#!/bin/bash
for i in $(LANG=en_US seq 0.5 0.25 2)
do
    for j in $(LANG=en_US seq 0.001 0.001 0.005)
    do
	echo "++++++++++++" $i $j "++++++++++++"
	tornettools generate \
	    relayinfo_staging_2020-11-01--2020-11-30.json \
	    userinfo_staging_2020-11-01--2020-11-30.json \
	    networkinfo_staging.gml \
	    tmodel-ccs2018.github.io \
	    --network_scale $j \
	    --prefix simulation-$j-$i \
	    --load_scale $i

	tornettools simulate -a '--parallelism=12 --seed=123 --template-directory=shadow.data.template' simulation-$j-$i
	tornettools parse simulation-$j-$i
	tornettools plot \
	    simulation-$j-$i \
	    --tor_metrics_path  tor_metrics_2020-11-01--2020-11-30.json \
	    --prefix pdfs-simulation-$j-$i
	#tornettools archive simulation-$j-$i
    done
done
