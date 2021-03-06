#!../../bin/linux-x86_64-debug/psc

#< envPaths
epicsEnvSet("ARCH","linux-x86-debug")
epicsEnvSet("IOC","iocpscenc")
epicsEnvSet("TOP","/epics/iocs/pscdrv")
epicsEnvSet("DEVIOCSTATS","/usr/lib/epics")
epicsEnvSet("CAPUTLOG","/usr/lib/epics")
epicsEnvSet("EPICS_BASE","/usr/lib/epics")

epicsEnvSet("IOCNAME", "iocpscenc")
epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST", "NO")
epicsEnvSet("EPICS_CA_ADDR_LIST", "10.6.128.255")

cd ${TOP}

epicsEnvSet("ENGINEER","Chanaka De Silva x2962")
epicsEnvSet("LOCATION","06BMA")

## Register all support components
dbLoadDatabase("dbd/psc.dbd",0,0)
psc_registerRecordDeviceDriver(pdbbase) 

## Load record instances for xf07bm-enc
dbLoadRecords("db/EncoderRx.db","Sys=XF:06BM-CT,Dev=Enc01,Chan=1,ID=51")
dbLoadRecords("db/EncoderRx.db","Sys=XF:06BM-CT,Dev=Enc01,Chan=2,ID=52")
dbLoadRecords("db/EncoderRx.db","Sys=XF:06BM-CT,Dev=Enc01,Chan=3,ID=53")
dbLoadRecords("db/EncoderRx.db","Sys=XF:06BM-CT,Dev=Enc01,Chan=4,ID=54")
dbLoadRecords("db/EncoderRx.db","Sys=XF:06BM-CT,Dev=Enc01,Chan=DI,ID=55")
dbLoadRecords("db/EncoderTx.db","Sys=XF:06BM-CT,Dev=Enc01")
dbLoadRecords("db/EncoderSts.db","Sys=XF:06BM-CT,Dev=Enc01")
dbLoadRecords("db/iocAdminSoft.db","IOC=XF:06BM-CT{IOC:PB01}")

createPSC("TxEnc01", "10.6.130.101", 7,0)
createPSC("RxEnc01", "10.6.130.101", 20,1)

#asSetFilename("${TOP}/DEFAULT.acf")

system("install -d ${TOP}/as")
system("install -m 777 -d ${TOP}/as/save")
system("install -m 777 -d ${TOP}/as/req")

### Save/Restore ###
dbLoadRecords("db/save_restoreStatus.db", "P=XF:06BM-CT{IOC:${IOCNAME}}")
save_restoreSet_status_prefix("XF:06BM-CT{IOC:${IOCNAME}}")
set_savefile_path("${TOP}/as","/save")
set_requestfile_path("${TOP}/as","/req")

set_pass0_restoreFile("ioc_settings.sav")
set_pass0_restoreFile("ioc_values.sav")

var(PSCDebug, 2)

iocInit()

dbl > /cf-update/xf06bma-ioc1.pscdrv.dbl
#system "cp records.dbl /cf-update/$HOSTNAME.$IOCNAME.dbl"

### Save/Restore ###
makeAutosaveFileFromDbInfo("${TOP}/as/req/ioc_settings.req", "autosaveFields_pass0")
makeAutosaveFileFromDbInfo("${TOP}/as/req/ioc_values.req", "autosaveFields")

create_monitor_set("ioc_settings.req", 5, "")
create_monitor_set("ioc_values.req", 5, "")

#caPutLogInit("10.0.152.133:7004", 1)

