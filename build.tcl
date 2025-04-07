# Set DB to Oracle
dbset db ora

set env(TNS_ADMIN) "[file normalize ../oracle-net]"
set env(ORACLE_HOME) "/usr/lib/oracle/19.26/client64"
set env(LD_LIBRARY_PATH) "$env(ORACLE_HOME)/lib"


diset connection system_user system
diset connection system_password $env(ORACLE_SYSTEM_PASSWORD)
diset connection instance oralab


# Set TPC-C workload parameters
diset tpcc ora_user tpcc
diset tpcc ora_pass tpcc
diset tpcc ora_tablespace USERS
diset tpcc ora_storage "DEFAULT"
diset tpcc ora_count_ware 10
diset tpcc ora_num_vu 10
diset tpcc ora_durability nologging

# Build schema
buildschema

# Wait for build to complete
proc wait_to_complete {} {
    global complete
    set complete [vucomplete]
    if {!$complete} {
        after 5000 wait_to_complete
    } else {
        exit
    }
}

wait_to_complete
vwait forever