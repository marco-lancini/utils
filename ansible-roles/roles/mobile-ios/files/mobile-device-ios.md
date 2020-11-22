# On-device iOS Tools

## Needle's Prerequisites

Name           	| Cydia Package     | Description               | URL
------------- 	| -------------		| -------------             | -------------
Cydia 			| 					| Alternate Market  		| https://cydia.saurik.com/
OpenSSH			| `OpenSSH`			| SSH 						|
APT				| `Apt 0.7 Strict`	| Package Manager			|


## Automated by Needle (`set SETUP_DEVICE True`)

Name           	| Package      										 | Repo        								     | Description           	| URL
------------- 	| -------------										 | ------------- 							     | -------------         	| -------------
BigBoss 		| `bigbosshackertools` 								 | `http://apt.thebigboss.org/repofiles/cydia/`  | Common unix tools 	    |
Class-dump 		| `pcre`, `net.limneos.classdump-dyld`, `class-dump` | 												 | Dump class interfaces	| 
Clutch2 		| `com.iphonecake.clutch2`						     | `http://cydia.iphonecake.com` 				 | Decrypt app binary		|
coreutils 		| `coreutils`, `coreutils-bin`						 |												 | Core UNIX utilities 		|
Cycript			| `cycript`											 | 												 | Hooking					| http://www.cycript.com
Darwin CC Tools | `org.coolstar.cctools`							 |				  								 | Inspect binary's properties (`otool`, `lipo`, etc.) |
FileDP 			|													 |												 | Data Protection Class 	| http://www.securitylearn.net/2012/10/18/extracting-data-protection-class-from-files-on-ios/
Frida 			| `re.frida.server`									 | `https://build.frida.re`						 | Hooking					| http://www.frida.re
Fsmon 			|													 |												 | Monitor filesystem changes| https://github.com/nowsecure/fsmon
GDB 			| `gdb`												 | `http://cydia.radare.org/`					 | Debugger 				|
Ipainstaller 	| `com.autopear.installipa` 						 | 												 | Install an IPA from the filesystem | 
Keychain_Dump   |													 | 												 | Dump keychain			|
Ldid 			| `ldid`											 | 												 | Sign binaries			|
Ondeviceconsole | `com.eswick.ondeviceconsole`						 |												 | Access syslog			|
Open			| `com.conradkramer.open`							  												 | Launch applications		|
PBWatcher 		|													 |												 | Dump the OS Pasteboard	| https://github.com/dmayer/pbwatcher/
Plutil 			| `com.ericasadun.utilities` 						 | 												 | Manipulate Plists  		|
SSL Kill Switch |                                                    |                                               | Disable Pinning | 
Theos 			| 						 | 												 | Development Environment for Tweaks  		| https://github.com/theos/theos/wiki/Installation

* Update Cydia repositories: `apt-get update`
* Upgrade all Cydia changes: `apt-get upgrade`
* Append source to Cydia source list: `echo "deb {url} ./" >> /etc/apt/sources.list.d/cydia.list`
* Search packages available for installation: `apt-cache search <app>`
* Install application: `apt-get install -y {package}`
* List all installed apps/packages: `dpkg -l`


- - - 

## MANUAL


### iOS SSL Kill Switch

Disable pinning (https://github.com/iSECPartners/ios-ssl-kill-switch):

```
	iphone:# apt-get install preferenceloader
	iphone:# wget https://github.com/iSECPartners/ios-ssl-kill-switch/releases/download/release-0.6/com.isecpartners.nabla.sslkillswitch_v0.6-iOS_7.0.deb
	iphone:# dpkg -i com.isecpartners.nabla.sslkillswitch_v0.6-iOS_7.0.deb
	iphone:# killall -HUP SpringBoard
```


### Theos

Development environment for tweaks (https://github.com/DHowett/theos):

```
    iphone:# echo "deb http://coolstar.org/publicrepo ./" >> /etc/apt/sources.list.d/cydia.list
    iphone:# apt-get install org.coolstar.iostoolchain
    iphone:# apt-get install org.coolstar.perl

    iphone:#  GIT_SSL_NO_VERIFY=true git clone --recursive https://github.com/theos/theos.git /private/var/theos
    iphone:#  mkdir -p /private/var/theos/sdks
    iphone:#  curl -ksL \"https://sdks.website/dl/iPhoneOS8.1.sdk.tbz2\" | tar -xj -C /private/var/theos/sdks
```
