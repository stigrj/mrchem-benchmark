#!/bin/bash -l

function get_scf_cycle {
    sed -n "/SCF cycle  ${1}/,/### Wall time/p" ${2}
}

function get_block {
    sed -n "/${1}/,/Wall time/p"
}

function get_wall_time {
    sed -n "/${1}/,/Wall time/p" \
    | grep -m 1 'Wall time' \
    | awk '{ print $3 }'
}

current_dir=`pwd`
outfile=${current_dir}/kain.csv
echo "molecule,MPI,OMP,orbs,Push back,Setup linear system,Solve linear system,Expand solution,Total KAIN" > ${outfile}

#for mol in 002; do
#    cd alkane-${mol}_s
#    for prec in 4; do
#        for mpi in 01; do
#            for omp in 04; do
for mol in 010 020 030 040 050 060 070 090; do
    cd alkane-${mol}_s
    for prec in 5; do
        for mpi in 008 016 032 048 064 080 096 112 128 144 160; do
            for omp in 08 16 32; do
                inpfile=prec_${prec}_mpi_${mpi}_omp_${omp}.out
                if [ -f ${inpfile} ]; then
                    n_orbs=`grep 'OrbitalVector' ${inpfile} \
                        | awk '{ print $2 }'`
                    push_back=`get_scf_cycle 4 ${inpfile} \
                        | get_block 'Iterative subspace accelerator' \
                        | grep 'Push back orbitals' \
                        | awk '{ print $4 }'`
                    setup=`get_scf_cycle 4 ${inpfile} \
                        | get_block 'Iterative subspace accelerator' \
                        | grep 'Setup linear system' \
                        | awk '{ print $4 }'`
                    solve=`get_scf_cycle 4 ${inpfile} \
                        | get_block 'Iterative subspace accelerator' \
                        | grep 'Solve linear system' \
                        | awk '{ print $4 }'`
                    expand=`get_scf_cycle 4 ${inpfile} \
                        | get_block 'Iterative subspace accelerator' \
                        | grep 'Expand solution' \
                        | awk '{ print $3 }'`
                    kain_tot=`get_scf_cycle 4 ${inpfile} \
                        | get_wall_time 'Iterative subspace accelerator'`
                    echo "alkane_${mol},${mpi},${omp},${n_orbs},${push_back},${setup},${solve},${expand},${kain_tot}" >> ${outfile}
                fi
            done
        done
    done
    cd ..
done

