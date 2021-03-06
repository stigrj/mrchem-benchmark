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
outfile=${current_dir}/scf.csv
echo "molecule,MPI,OMP,orbs,Localize,SCF energy,Helmholtz,Lowdin,KAIN,Fock operator,Fock matrix,Total SCF" > ${outfile}

#for mol in 002; do
#    cd alkane-${mol}_s
#    for prec in 4; do
#        for mpi in 01; do
#            for omp in 04; do
for mol in 010 020 030 040 050 060 070 090; do
    cd alkane-${mol}_s
    for prec in 5; do
        for mpi in 004 008 016 032 048 064 080 096 112 128 144 160; do
            for omp in 08 16 32; do
                inpfile=prec_${prec}_mpi_${mpi}_omp_${omp}.out
                if [ -f ${inpfile} ]; then
                    n_orbs=`grep 'OrbitalVector' ${inpfile} \
                        | awk '{ print $2 }'`
                    localize=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Localizing orbitals'`
                    scf_energy=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Calculating SCF energy'`
                    helm_rot=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Rotating Helmholtz argument'`
                    helm_app=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Applying Helmholtz operators'`
                    helmholtz=$(awk "BEGIN {print $helm_rot+$helm_app; exit}")
                    lowdin=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Lowdin orthonormalization'`
                    kain=`get_scf_cycle 4 ${inpfile} \
                        | get_wall_time 'Iterative subspace accelerator'`
                    fock_setup=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Setting up Fock operator'`
                    fock_calc=`get_scf_cycle 1 ${inpfile} \
                        | get_wall_time 'Calculating Fock matrix'`
                    scf_tot=`get_scf_cycle 1 ${inpfile} \
                        | grep -m 1 '### Wall time' \
                        | awk '{ print $4 }'`
                    echo "alkane_${mol},${mpi},${omp},${n_orbs},${localize},${scf_energy},${helmholtz},${lowdin},${kain},${fock_setup},${fock_calc},${scf_tot}" >> ${outfile}
                fi
            done
        done
    done
    cd ..
done


