* Upgrading to druid 0.14.0
## Current Release 
### 0.34.0 
**Release Date:** Mon Apr  8 16:50:25 UTC 2019     
## Previous Releases 
* Adding support for S3_BUCKET_NAME env variable, to allow one to specify which s3 bucket to use
### 0.32.0 
**Release Date:** Fri Mar 15 14:30:56 UTC 2019     
### 0.31.0 
**Release Date:** Fri Mar 15 13:28:24 UTC 2019     
### 0.30.0 
**Release Date:** Wed Feb  6 16:06:50 UTC 2019     
### 0.29.0 
**Release Date:** Thu Jan 24 18:14:39 UTC 2019     
### 0.28.0 
**Release Date:** Tue Jan 22 15:37:34 UTC 2019     
### 0.27.0 
**Release Date:** Tue Nov 27 19:26:04 UTC 2018     
### 0.26.0 
**Release Date:** Fri Nov 16 15:55:56 UTC 2018     
* Feature - Druid Metric export
### 0.25.0 
**Release Date:** Thu Nov 15 18:52:57 UTC 2018     
### 0.24.0 
**Release Date:** Wed Nov  7 20:32:45 UTC 2018     
* Feature - upgrading druid to 0.12.3

### 0.23.0 
**Release Date:** Wed Nov  7 20:23:06 UTC 2018     
* Feature - Made the druid cache size configurable via environment variables

### 0.22.0 
**Release Date:** Sun Oct 21 04:38:17 UTC 2018     
* Fix - Allowing configuration of middlemanager PEONS with the use of ENV variable DRUID_PEONS_JAVA_XMX
* Fix - When DRUID_HOSTNAME is not specified, the default inet hostame is used (typically, the docker container id). This is required to support scaling docker swarm services
### 0.21.0 
**Release Date:** Wed Sep 19 21:35:28 UTC 2018     
### 0.20.0 
**Release Date:** Wed Sep 19 21:24:48 UTC 2018     
### 0.19.0 
**Release Date:** Wed Sep 19 21:20:18 UTC 2018     
* Fix - Fixed bad Env variable name
### 0.18.0 
**Release Date:** Wed Sep 19 16:46:03 UTC 2018     
* Adding the DRUID_PEONS_JAVA_OPTS env variable to allow configuring memory for the peons from a docker-compose file (for instance)
### 0.17.0 
**Release Date:** Thu Sep  6 21:09:14 UTC 2018     
* Fix - Giving more memory to the middle manager Peons for 20k + TWAMP sessions systems

### 0.16.0 
**Release Date:** Fri Aug 17 20:02:54 UTC 2018     
* Feature - Upgrade to druid 0.12.0
* Feature - New sizing defaults for historical buffer (1Gb instead of 256mb), ensuring that we have enough space to process SLA reports
### 0.15.0 
**Release Date:** Wed Aug 15 21:13:14 UTC 2018     
* Feature - making druid.processing.numThreads configurable for historical nodes
### 0.14.0 
**Release Date:** Thu Jul  5 18:27:29 UTC 2018     
* Fix - fixed bad Entrypoint from previous fix
### 0.13.0 
**Release Date:** Thu Jul  5 15:54:16 UTC 2018     
* Fix - Fix defunct process preventing docker containers from being terminated gracefully in some cases. We added [dumb-init] to prevent defunct process from preventing docker service to upgrade a container that has a zombie process in it that is now owned by the host Init (and will thus not be reaped until a reboot)
### 0.12.0 
**Release Date:** Tue Jun 26 14:19:00 UTC 2018     
* Feature - Adding the java JDK with image so that all troubleshooting tools are shipped with the image
### 0.11.0 
**Release Date:** Mon Jun 25 17:47:16 UTC 2018     
* Feature - Made the middlemanager num workers configurable via ENV variable. It still defaults to "2", but it can be set with the DRUID_MIDDLEMANAGER_NUM_WORKERS env variable
### 0.10.0 
**Release Date:** Mon May  7 12:37:16 UTC 2018     
Fix - revert Druid version back to 0.11.0
### 0.9.0 
**Release Date:** Thu May  3 18:05:39 UTC 2018     
* Feature - reduce the amount of time the coordinator waits before updating lookups.
### 0.8.0 
**Release Date:** Tue Apr 24 15:28:59 UTC 2018     
Feature - upgrade to Druid version 0.12.0
### 0.7.0 
**Release Date:** Wed Feb 21 20:55:33 UTC 2018     
### 0.6.0 
**Release Date:** Tue Feb  6 16:14:46 UTC 2018     
* Fix for Middlemanager failing to start because [number of threads must be greater than 5](https://app.asana.com/0/520715087448242/549499425066572/f).
### 0.5.0 
**Release Date:** Sat Feb  3 17:07:15 UTC 2018     
### 0.4.0 
**Release Date:** Fri Jan 26 16:47:05 UTC 2018     
* fix - removing 'exec' from docker-entrypoint so that druid PID is not 1. Java process with PID 1 can't have their memory dumped by jmap

### 0.3.0 
**Release Date:** Wed Dec 20 00:17:01 UTC 2017     
#### Feature
* Upgrading druid to 0.11.0

### 0.2.0 
**Release Date:** Mon Nov 27 16:04:44 UTC 2017     
### 0.1.0
**Release Date:** Thu Nov 23 02:00:29 UTC 2017

