#!/bin/sh -e

mkdir -p fulldiag_kondo_chain/
cd fulldiag_kondo_chain

cat > stan.in <<EOF
L = 3
model = "Kondo"
method = "FullDiag"
lattice = "chain"
t = 1.0
J = 4.0
nelec = 3
2Sz = 0
EOF

${MPIRUNFC} ../../src/HPhi -s stan.in

# Check value

cat > reference.dat <<EOF
  <H>         <N>        <Sz>       <S2>       <D>
  -9.510820   6.000000  -0.000000   0.000000   0.081743
  -6.357216   6.000000   0.000000   2.000000   0.352104
  -6.357216   6.000000  -0.000000   2.000000   0.352104
  -5.207344   6.000000  -0.000000   2.000000   0.051121
  -4.765489   6.000000  -0.000000   0.000000   0.810380
  -4.765489   6.000000  -0.000000  -0.000000   0.810380
  -4.195013   6.000000  -0.000000   2.000000   0.739364
  -4.000000   6.000000   0.000000  -0.000000   0.711864
  -3.987295   6.000000  -0.000000   2.000000   0.759910
  -3.987295   6.000000  -0.000000   2.000000   0.759910
  -3.772002   6.000000   0.000000   0.000000   0.978776
  -3.278161   6.000000  -0.000000   2.000000   0.967984
  -2.679611   6.000000  -0.000000   0.000000   0.889620
  -2.679611   6.000000  -0.000000  -0.000000   0.889620
  -2.498456   6.000000  -0.000000   2.000000   0.666664
  -2.498456   6.000000  -0.000000   2.000000   0.666664
  -2.464102   6.000000  -0.000000   6.000000   0.454545
  -2.464102   6.000000  -0.000000   6.000000   0.454545
  -1.420259   6.000000   0.000000   2.000000   0.638765
  -1.142004   6.000000  -0.000000   2.000000   0.548707
  -1.142004   6.000000  -0.000000   2.000000   0.548707
  -1.000000   6.000000  -0.000000   2.255735   0.374427
  -1.000000   6.000000  -0.000000   3.483658   0.251634
  -1.000000   6.000000  -0.000000   0.260608   0.573939
  -0.770608   6.000000  -0.000000   2.000000   0.818588
  -0.340722   6.000000  -0.000000   0.000000   0.277695
  -0.000000   6.000000  -0.000000   1.226426   0.651669
   0.000000   6.000000  -0.000000   4.070421   0.596010
  -0.000000   6.000000   0.000000   3.445019   0.620388
   0.000000   6.000000   0.000000   4.029060   0.593495
  -0.000000   6.000000  -0.000000   3.229074   0.629347
   0.420259   6.000000  -0.000000   2.000000   0.783148
   0.679611   6.000000   0.000000   0.000000   0.889620
   0.679611   6.000000  -0.000000  -0.000000   0.889620
   0.771037   6.000000  -0.000000   2.000000   0.937408
   0.771037   6.000000  -0.000000   2.000000   0.937408
   1.000000   6.000000  -0.000000   6.000000   1.000000
   1.000000   6.000000  -0.000000   6.000000   1.000000
   1.353298   6.000000  -0.000000   2.000000   0.776266
   1.353298   6.000000   0.000000   2.000000   0.776266
   1.551049   6.000000   0.000000   2.000000   0.760461
   1.851542   6.000000  -0.000000   0.000000   0.928697
   2.000000   6.000000  -0.000000   6.000000   0.545455
   2.000000   6.000000  -0.000000   6.000000   0.545455
   2.169221   6.000000   0.000000   2.000000   0.902091
   2.169221   6.000000  -0.000000   2.000000   0.902091
   2.765489   6.000000   0.000000   0.000000   0.810380
   2.765489   6.000000  -0.000000  -0.000000   0.810380
   3.000000   6.000000   0.000000  12.000000   0.000000
   3.195013   6.000000   0.000000   2.000000   0.838723
   4.464102   6.000000  -0.000000   6.000000   0.454545
   4.464102   6.000000   0.000000   6.000000   0.454545
   4.691416   6.000000  -0.000000   2.000000   0.390183
   4.691416   6.000000   0.000000   2.000000   0.390183
   4.705065   6.000000   0.000000   2.000000   0.401846
   4.772002   6.000000  -0.000000  -0.000000   0.354557
EOF
paste output/zvo_phys_Nup3_Ndown3.dat reference.dat > paste.dat
diff=`awk '
BEGIN{diff=0.0} 
NR>1{diff+=sqrt(($1-$6)*($1-$6))} 
END{printf "%8.6f", diff/NR}
' paste.dat`
echo "Diff : " $diff
test "${diff}" = "0.000000"

exit $?
