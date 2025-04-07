# HammerDB Oracle Benchmark Setup

This repo automates Oracle TPCC benchmark runs using HammerDB. It includes scripts to set up the environment, run schema builds, and execute workloads — with support for Oracle connection via tns file `tnsnames.ora` with TCL.

---

## Project Structure

```
hammerdb-setup/
├── HammerDB-4.12/               # Extracted HammerDB CLI
├── download-hammerdb.sh         # Installs HammerDB if needed
├── build.sh                     # Builds the TPCC schema
├── run.sh                       # Runs the workload benchmark
├── build.tcl                    # TCL script to create schema
├── run.tcl                      # TCL script to execute workload
├── oracle-net/
│   └── tnsnames.ora            # Custom Oracle TNS config (optional)
├── results/                     # Benchmark logs & output
```



## Requirements

- Oracle Instant Client (via dnf, version 19+)
- Oracle DB reachable from the OCPV VM test it with sqlplus before
- Packages: `tcl`, `tcl-devel`, `libaio`, `curl`, `unzip` will be installed with `build.sh` script.

---

## Configuration

### 1. TNS alias (`tnsnames.ora`)

If you're using `tnsnames.ora`, edit it under `oracle-net/`:

```ini
MYDB =
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST=yourhost)(PORT=1521))
    (CONNECT_DATA =
      (SERVICE_NAME=pdb1) // you can it differenct 
    )
  )
```

### 2. HammerDB connection setup (`build.tcl` or `run.tcl`)

```tcl
set env(TNS_ADMIN) "[file normalize ./oracle-net]"
set env(ORACLE_HOME) "/usr/lib/oracle/19.26/client64"
set env(LD_LIBRARY_PATH) "$env(ORACLE_HOME)/lib"

diset connection instance MYDB
diset connection system_user system
diset connection system_password $env(ORACLE_SYSTEM_PASSWORD)
```

### 3. Environment Variables (`build.sh` or `run.sh`)

update it in both script the password for oracle for the user `system`

```bash
export ORACLE_SYSTEM_PASSWORD=yourpassword
```

---

## Running the Benchmark

### Build schema:
```bash
./build.sh
```

### Run workload:
```bash
./run.sh
```

Output goes to:
- `results/hammerdb_run_<timestamp>.log`
- `results/hammerdb_nopm_<timestamp>.log`

if want to generate cvs file run `./create-csv-result.sh`

---

## Resting Schema

```sql

DROP USER tpcc CASCADE;
     
```

---

## Common Issues

**ORA-12154**: Could not resolve connect identifier
- Your `tnsnames.ora` might be missing or misconfigured
- Confirm `TNS_ADMIN` is correctly set

**ORA-65096**: Common user or role name must start with C##

- This occurs when using a containerized (CDB) database service.
- You're likely trying to create a user in the CDB root — instead, switch to a Pluggable Database (PDB), such as pdb1.
- Alternatively, create the user and tablespace using plsql with the C## prefix and then try hamerdb scripts.

---


