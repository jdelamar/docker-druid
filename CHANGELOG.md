* Fix - fixed bad Entrypoint from previous fix
## Current Release 
### 0.13.0 
**Release Date:** Thu Jul  5 15:54:16 UTC 2018     
## Previous Releases 
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

