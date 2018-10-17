#!/bin/bash
#SBATCH -N 1
#SBATCH -n 20
#SBATCH -e transfer_%A.err            # File to which STDERR will be written
#SBATCH -o transfer_%A.out           # File to which STDOUT will be written
#SBATCH -J transfer          # Job name
#SBATCH --mail-type=ALL              # Type of email notification- BEGIN,END,FAIL,ALL
#SBATCH --mem=64000
#SBATCH --time=6-23:00:00              # Runtime in D-HH:MM:SS
#SBATCH --qos=long


wget http://comanche.molgen.mpg.de/orn/bakker/iGZUjJeml72saJzFAqCwTuy99XGvNN4n/mpg_L13578-1_B14_S25_R1_001.fastq.gz
wget http://comanche.molgen.mpg.de/orn/bakker/iGZUjJeml72saJzFAqCwTuy99XGvNN4n/mpg_L13578-1_B14_S25_R1_001.fastq.gz.md5
wget http://comanche.molgen.mpg.de/orn/bakker/iGZUjJeml72saJzFAqCwTuy99XGvNN4n/mpg_L13578-1_B14_S25_R2_001.fastq.gz
wget http://comanche.molgen.mpg.de/orn/bakker/iGZUjJeml72saJzFAqCwTuy99XGvNN4n/mpg_L13578-1_B14_S25_R2_001.fastq.gz.md5

# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13541-2_F32_S1_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13541-2_F32_S1_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13542-1_F46_S2_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13542-1_F46_S2_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13543-1_F18_S3_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13543-1_F18_S3_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13544-1_F34_S4_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13544-1_F34_S4_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13545-1_F47_S5_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13545-1_F47_S5_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13546-1_F84_S6_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13546-1_F84_S6_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13547-1_F53_S7_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13547-1_F53_S7_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13548-1_F110_S10_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13548-1_F110_S10_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13549-1_F83_S11_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13549-1_F83_S11_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13550-1_F116_S12_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13550-1_F116_S12_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13551-1_F91_S13_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13551-1_F91_S13_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13552-1_F109_S14_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13552-1_F109_S14_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13553-1_F82_S15_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13553-1_F82_S15_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13554-1_F40_S16_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13554-1_F40_S16_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13555-1_F56_S19_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13555-1_F56_S19_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13556-1_F36-2_S20_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13556-1_F36-2_S20_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13557-1_F38_S21_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13557-1_F38_S21_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13558-1_F41_S22_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13558-1_F41_S22_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13559-1_F55_S23_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13559-1_F55_S23_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13560-1_F90_S24_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13560-1_F90_S24_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13561-1_F97_S25_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13561-1_F97_S25_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13562-1_F99_S28_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13562-1_F99_S28_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13563-1_F100_S29_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13563-1_F100_S29_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13564-1_F87_S30_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13564-1_F87_S30_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13565-1_F95_S31_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13565-1_F95_S31_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13566-1_F101_S32_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13566-1_F101_S32_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13567-1_B02_S33_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13567-1_B02_S33_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13568-1_B04_S34_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13568-1_B04_S34_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13569-1_B05_S37_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13569-1_B05_S37_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13570-1_B06_S38_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13570-1_B06_S38_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13571-1_B07_S39_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13571-1_B07_S39_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13572-1_B08_S40_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13572-1_B08_S40_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13573-1_B09_S41_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13573-1_B09_S41_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13574-1_B10_S42_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13574-1_B10_S42_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13575-1_B11_S43_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13575-1_B11_S43_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13576-1_B12_S44_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13576-1_B12_S44_R2_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13577-1_B13_S45_R1_001.fastq.gz
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13577-1_B13_S45_R2_001.fastq.gz
#
# # MD5 Checksums
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13541-2_F32_S1_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13541-2_F32_S1_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13542-1_F46_S2_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13542-1_F46_S2_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13543-1_F18_S3_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13543-1_F18_S3_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13544-1_F34_S4_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13544-1_F34_S4_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13545-1_F47_S5_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13545-1_F47_S5_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13546-1_F84_S6_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13546-1_F84_S6_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13547-1_F53_S7_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13547-1_F53_S7_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13548-1_F110_S10_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13548-1_F110_S10_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13549-1_F83_S11_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13549-1_F83_S11_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13550-1_F116_S12_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13550-1_F116_S12_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13551-1_F91_S13_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13551-1_F91_S13_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13552-1_F109_S14_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13552-1_F109_S14_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13553-1_F82_S15_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13553-1_F82_S15_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13554-1_F40_S16_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13554-1_F40_S16_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13555-1_F56_S19_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13555-1_F56_S19_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13556-1_F36-2_S20_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13556-1_F36-2_S20_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13557-1_F38_S21_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13557-1_F38_S21_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13558-1_F41_S22_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13558-1_F41_S22_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13559-1_F55_S23_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13559-1_F55_S23_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13560-1_F90_S24_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13560-1_F90_S24_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13561-1_F97_S25_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13561-1_F97_S25_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13562-1_F99_S28_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13562-1_F99_S28_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13563-1_F100_S29_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13563-1_F100_S29_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13564-1_F87_S30_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13564-1_F87_S30_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13565-1_F95_S31_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13565-1_F95_S31_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13566-1_F101_S32_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13566-1_F101_S32_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13567-1_B02_S33_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13567-1_B02_S33_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13568-1_B04_S34_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13568-1_B04_S34_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13569-1_B05_S37_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13569-1_B05_S37_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13570-1_B06_S38_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13570-1_B06_S38_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13571-1_B07_S39_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13571-1_B07_S39_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13572-1_B08_S40_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13572-1_B08_S40_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13573-1_B09_S41_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13573-1_B09_S41_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13574-1_B10_S42_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13574-1_B10_S42_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13575-1_B11_S43_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13575-1_B11_S43_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13576-1_B12_S44_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13576-1_B12_S44_R2_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13577-1_B13_S45_R1_001.fastq.gz.md5
# wget http://comanche.molgen.mpg.de/orn/bakker/c803a2c06c7db7ad2b561bd2627c6fca/mpg_L13577-1_B13_S45_R2_001.fastq.gz.md5
