#!/bin/bash

name=$1
mol=${name%_*}
mult=${name#*_}

mrchem_version='mrchem-mar-2019'
min_scale=-5
max_scale=20
angstrom='true'
method='DFT'
functional='PBE'
canonical='false'
rotation=5
kain=3
max_iter=5
guess='SAD_DZ'
dev_hr=1
pre_hr=12
full_hr=2
xyz_dir='/cluster/home/stig/benchmarks-mrchem/molecules/caffeine'

if [[ $mult == 's' ]]; then mult=1; fi
if [[ $mult == 'd' ]]; then mult=2; fi
if [[ $mult == 't' ]]; then mult=3; fi
if [[ $mult == 'q' ]]; then mult=4; fi

restricted='true'
if [[ $mult > 1 ]]; then restricted='false'; fi

cd $name
for prec in 5; do
    threshold=$((${prec}-1))
    for MPI in 001 002 004 008 016 032 048; do
        for OMP in 01 02 04 08 16 32; do
            file_name=prec_${prec}_mpi_${MPI}_omp_${OMP}
            echo ${file_name}

            cp ../mrchem.inp                             ${file_name}.inp
            sed -i "/coords/r ${xyz_dir}/${mol}.xyz"     ${file_name}.inp
            sed -i "s/REL_PREC/${prec}/"                 ${file_name}.inp
            sed -i "s/MIN_SCALE/${min_scale}/"           ${file_name}.inp
            sed -i "s/MAX_SCALE/${max_scale}/"           ${file_name}.inp
            sed -i "s/MULTIPLICITY/${mult}/"             ${file_name}.inp
            sed -i "s/ANGSTROM/${angstrom}/"             ${file_name}.inp
            sed -i "s/METHOD/${method}/"                 ${file_name}.inp
            sed -i "s/RESTRICTED/${restricted}/"         ${file_name}.inp
            sed -i "s/XC_FUNC/${functional}/"            ${file_name}.inp
            sed -i "s/KAIN/${kain}/"                     ${file_name}.inp
            sed -i "s/ROTATION/${rotation}/"             ${file_name}.inp
            sed -i "s/MAXIT/${max_iter}/"                ${file_name}.inp
            sed -i "s/CANONICAL/${canonical}/"           ${file_name}.inp
            sed -i "s/ORB_THRS/${threshold}/"            ${file_name}.inp
            sed -i "s/INITIAL_GUESS/${guess}/"           ${file_name}.inp
                                                         
            cp ../mrchem.run                             ${file_name}.run
            sed -i "s/NAME/${name}_${prec}/"             ${file_name}.run
            sed -i "s/MRCHEM_VERSION/${mrchem_version}/" ${file_name}.run
            sed -i "s/INPUT/${file_name}/"               ${file_name}.run
            sed -i "s/OUTPUT/${file_name}/"              ${file_name}.run
        done
    done
done

run_file=mpi_001_omp_01
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_001_omp_02
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_001_omp_04
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_001_omp_08
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_001_omp_16
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_001_omp_32
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_01
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_02
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_04
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_08
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_16
sed -i "s/NODES/1/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${pre_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=preproc" *${run_file}*.run

run_file=mpi_002_omp_32
sed -i "s/NODES/2/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${dev_hr}/"                 *${run_file}*.run
sed -i "/partition/a #SBATCH --qos=devel"   *${run_file}*.run
sed -i "/partition/a #SBATCH --nice=500"    *${run_file}*.run

run_file=mpi_004_omp_01
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_004_omp_02
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_004_omp_04
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_004_omp_08
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_004_omp_16
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_004_omp_32
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_01
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_02
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_04
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_08
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_16
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_008_omp_32
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_01
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_02
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_04
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_08
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_16
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_016_omp_32
sed -i "s/NODES/16/"                        *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_01
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_02
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_04
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_08
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_16
sed -i "s/NODES/16/"                        *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_032_omp_32
sed -i "s/NODES/32/"                        *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_01
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/12/"                        *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_02
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/12/"                        *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_04
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/12/"                        *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_08
sed -i "s/NODES/12/"                        *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_16
sed -i "s/NODES/24/"                        *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_048_omp_32
sed -i "s/NODES/48/"                        *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_01
sed -i "s/NODES/4/"                         *${run_file}*.run
sed -i "s/TASKS/16/"                        *${run_file}*.run
sed -i "s/CPUS/1/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_02
sed -i "s/NODES/8/"                         *${run_file}*.run
sed -i "s/TASKS/8/"                         *${run_file}*.run
sed -i "s/CPUS/2/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_04
sed -i "s/NODES/16/"                        *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/4/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_08
sed -i "s/NODES/16/"                        *${run_file}*.run
sed -i "s/TASKS/4/"                         *${run_file}*.run
sed -i "s/CPUS/8/"                          *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_16
sed -i "s/NODES/32/"                        *${run_file}*.run
sed -i "s/TASKS/2/"                         *${run_file}*.run
sed -i "s/CPUS/16/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

run_file=mpi_064_omp_32
sed -i "s/NODES/64/"                        *${run_file}*.run
sed -i "s/TASKS/1/"                         *${run_file}*.run
sed -i "s/CPUS/32/"                         *${run_file}*.run
sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_080_omp_08
#sed -i "s/NODES/20/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_080_omp_16
#sed -i "s/NODES/40/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_080_omp_32
#sed -i "s/NODES/80/"                        *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_096_omp_08
#sed -i "s/NODES/24/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_096_omp_16
#sed -i "s/NODES/48/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_096_omp_32
#sed -i "s/NODES/96/"                        *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_112_omp_08
#sed -i "s/NODES/28/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_112_omp_16
#sed -i "s/NODES/56/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_112_omp_32
#sed -i "s/NODES/112/"                       *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_128_omp_08
#sed -i "s/NODES/32/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_128_omp_16
#sed -i "s/NODES/64/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_128_omp_32
#sed -i "s/NODES/128/"                       *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_144_omp_08
#sed -i "s/NODES/36/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_144_omp_16
#sed -i "s/NODES/72/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_144_omp_32
#sed -i "s/NODES/144/"                       *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_160_omp_08
#sed -i "s/NODES/40/"                        *${run_file}*.run
#sed -i "s/TASKS/4/"                         *${run_file}*.run
#sed -i "s/CPUS/8/"                          *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_160_omp_16
#sed -i "s/NODES/80/"                        *${run_file}*.run
#sed -i "s/TASKS/2/"                         *${run_file}*.run
#sed -i "s/CPUS/16/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

#run_file=mpi_160_omp_32
#sed -i "s/NODES/160/"                       *${run_file}*.run
#sed -i "s/TASKS/1/"                         *${run_file}*.run
#sed -i "s/CPUS/32/"                         *${run_file}*.run
#sed -i "s/HOURS/${full_hr}/"                *${run_file}*.run

