#PBS -lwalltime={wall_hours}:00:00
#PBS -lnodes=1
#PBS -S /bin/bash
#PBS -N {job_name}
#PBS -j oe
#PBS -o {log_name}
::PICO_ARRAY_ONLY::#PBS -t 1-{array_jobs}

# sleep option (for preventing race conditions on network file systems)
sleep {sleep_time}

# setup resources
use R

# main command line
{cmd_string}

# eof
