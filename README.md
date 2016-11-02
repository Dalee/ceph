# Ceph Test Stand

Goal is to make Vagrant machine running properly configured Ceph with set of preinstalled
software (like s3cmd).

Suitable for developing / testing purposes

## Known issues

 * `vagrant provision` destroys buckets.

 * Sometimes, ansible can fail with message:
```
==> default: TASK [Dalee.install-ceph : ceph - check user already created] ******************
==> default: fatal: [localhost]: FAILED! => {"changed": true, "cmd": "radosgw-admin user info --uid=s3user", "delta": "0:00:07.158828", "end": "2016-08-23 18:41:58.676083", "failed": true, "failed_when_result": true, "rc": 22, "start": "2016-08-23 18:41:51.517255", "stderr": "2016-08-23 18:41:52.571112 7f6fe32e97c0  0 couldn't find old data placement pools config, setting up new ones for the zone\n2016-08-23 18:41:52.576800 7f6fe32e97c0 -1 error storing region info: (17) File exists\n2016-08-23 18:41:52.576817 7f6fe32e97c0  0 create_default() returned -EEXIST,
we raced with another region creation\ncould not fetch user info: no user info saved", "stdout": "", "stdout_lines": [], "warnings": []}
```

Solution: run `vagrant provision` again.

 * Sometimes, ansible get stuck on task:
```
==> default: TASK [Dalee.install-ceph : ceph - check user already created] ******************
```

Solution: inside of vagrant vm run:
```
ps uax | grep radosgw-admin
sudo kill <pid-of-radosgw>
```

And run `vagrant provision` again.

 * Ceph assumes that IP address of any running machine is never changed. Using vagrant with 
 `dhcp` network adapter, IP address may change.
 
Solution: run `vagrant provision` again, and if it doesn't help 
run inside of Vagrant vm: `sudo rm -rf /var/lib/ceph`, and run `vagrant provision` again.


## Check cluster healt

```
vagrant@ceph [/home/web/ceph] > ceph -s
    cluster 52ffcc3b-2723-4c86-a394-13f0b26f89c5
     health HEALTH_OK
     monmap e1: 1 mons at {ceph=172.28.128.3:6789/0}
            election epoch 2, quorum 0 ceph
     osdmap e18: 1 osds: 1 up, 1 in
      pgmap v20: 128 pgs, 9 pools, 2174 bytes data, 54 objects
            2231 MB used, 35003 MB / 39251 MB avail
                 128 active+clean
  client io 12217 B/s rd, 1437 B/s wr, 32 op/s
```

If health not in `HEALTH_OK` state, check Known issues.

## Run

```bash
vagrant up
vagrant ssh
make vagrant
```

And check `http://ceph.local/files` and `http://ceph.local/htdocs`.


## What included?

User with credentials below will be created:
```
uid: s3user
access_key: tohF1taivo2ohlaec3eelud9ahWahs9c
secret_key: Shaesh8dee2ohei5aeMeeFaaPai4oh5U
```

And two buckets: `htdocs` and `files`:
```
vagrant@ceph [/home/web/ceph] > s3cmd ls
2016-08-23 15:59  s3://files
2016-08-23 15:59  s3://htdocs
```

## Sample s3cmd file operations

```
vagrant@ceph [/home/web/ceph] > s3cmd put ./README.md s3://files/test-put/README.md
./README.md -> s3://files/test-put/README.md  [1 of 1]
 3291 of 3291   100% in    0s   345.91 kB/s  done

vagrant@ceph [/home/web/ceph] > s3cmd ls s3://files/test-put/
2016-08-24 07:28      3291   s3://files/test-put/README.md

vagrant@ceph [/home/web/ceph] > s3cmd get s3://files/test-put/README.md ~/readme.md
s3://files/test-put/README.md -> /home/vagrant/readme.md  [1 of 1]
 3754 of 3754   100% in    0s    19.41 kB/s  done
```
