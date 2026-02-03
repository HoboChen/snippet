fio --name=precond_raw --filename=fill.dat --rw=write --bs=1M \
  --iodepth=32 --numjobs=1 --direct=1 --ioengine=libaio \
  --time_based --runtime=0 --group_reporting

fio --name=randrw_nearfull \
  --directory=. --filename=bench.dat --size=1G \
  --rw=randrw --rwmixread=50 \
  --bs=4k --iodepth=32 --numjobs=4 \
  --direct=1 --ioengine=libaio \
  --time_based --runtime=60 --group_reporting \
  --norandommap=1 --randrepeat=0
