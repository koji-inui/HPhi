#!/bin/sh -e

mkdir -p fulldiag_spingc_tri/
cd fulldiag_spingc_tri

cat > stan.in <<EOF
a0w = 3
a0l = 0
a1w = -1
a1l = 2
model = "SpinGC"
method = "FullDiag"
lattice = "triangular"
J = 1.0
EOF

${MPIRUNFC} ../../src/HPhi -s stan.in

# Check value

cat > reference.dat <<EOF
  <H>         <N>        <Sz>       <S2>       <D>
  -4.500000   6.000000   0.000000   0.000000   0.000000
  -4.500000   6.000000  -0.000000  -0.000000   0.000000
  -3.500000   6.000000   0.000102   2.000000   0.000000
  -3.500000   6.000000  -0.999880   2.000000   0.000000
  -3.500000   6.000000   0.999779   2.000000   0.000000
  -3.137459   6.000000  -0.794116   2.000000   0.000000
  -3.137459   6.000000   0.100116   2.000000   0.000000
  -3.137459   6.000000   0.997615   2.000000   0.000000
  -3.137459   6.000000  -0.815164   2.000000   0.000000
  -3.137459   6.000000  -0.380757   2.000000   0.000000
  -3.137459   6.000000   0.892306   2.000000   0.000000
  -2.500000   6.000000  -0.000000   0.000000   0.000000
  -2.500000   6.000000  -0.000000   0.000000   0.000000
  -2.000000   6.000000   0.992460   2.000000   0.000000
  -2.000000   6.000000   0.014585   2.000000   0.000000
  -2.000000   6.000000  -0.617460   2.000000   0.000000
  -2.000000   6.000000  -0.386791   2.000000   0.000000
  -2.000000   6.000000  -0.984781   2.000000   0.000000
  -2.000000   6.000000   0.981987   2.000000   0.000000
  -0.500000   6.000000   0.337224   2.000000   0.000000
  -0.500000   6.000000   0.095955   2.000000   0.000000
  -0.500000   6.000000  -0.388543   2.000000   0.000000
  -0.500000   6.000000  -0.296993   2.000000   0.000000
  -0.500000   6.000000   0.999811   2.000000   0.000000
  -0.500000   6.000000  -0.747454   2.000000   0.000000
   0.000000   6.000000   1.843942   6.000000   0.000000
  -0.000000   6.000000   0.092799   6.000000   0.000000
  -0.000000   6.000000   0.233003   6.000000   0.000000
   0.000000   6.000000   0.833734   6.000000   0.000000
  -0.000000   6.000000  -1.775754   6.000000   0.000000
   0.000000   6.000000  -1.458166   6.000000   0.000000
  -0.000000   6.000000   1.975228   6.000000   0.000000
  -0.000000   6.000000  -0.199170   6.000000   0.000000
  -0.000000   6.000000  -0.447459   6.000000   0.000000
  -0.000000   6.000000  -1.098157   6.000000   0.000000
   0.500000   6.000000  -0.148249   5.549678   0.000000
   0.500000   6.000000   0.242154   5.980070   0.000000
   0.500000   6.000000  -1.934345   5.990071   0.000000
   0.500000   6.000000  -0.085994   1.484013   0.000000
   0.500000   6.000000  -0.065656   4.996356   0.000000
   0.500000   6.000000   1.992091   5.999812   0.000000
   0.637459   6.000000  -0.960244   2.000000   0.000000
   0.637459   6.000000  -0.726320   2.000000   0.000000
   0.637459   6.000000   0.050568   2.000000   0.000000
   0.637459   6.000000   0.819129   2.000000   0.000000
   0.637459   6.000000  -0.072677   2.000000   0.000000
   0.637459   6.000000   0.889545   2.000000   0.000000
   2.000000   6.000000   1.895683   6.000000   0.000000
   2.000000   6.000000   0.768189   6.000000   0.000000
   2.000000   6.000000   1.050185   6.000000   0.000000
   2.000000   6.000000  -0.382165   6.000000   0.000000
   2.000000   6.000000  -1.444661   6.000000   0.000000
   2.000000   6.000000  -0.781705   6.000000   0.000000
   2.000000   6.000000  -0.935975   6.000000   0.000000
   2.000000   6.000000  -1.747409   6.000000   0.000000
   2.000000   6.000000  -0.416706   6.000000   0.000000
   2.000000   6.000000   1.994564   6.000000   0.000000
   4.500000   6.000000  -0.999994  12.000000   0.000000
   4.500000   6.000000   0.999568  12.000000   0.000000
   4.500000   6.000000   2.000000  12.000000   0.000000
   4.500000   6.000000   0.000426  12.000000   0.000000
   4.500000   6.000000  -2.000000  12.000000   0.000000
   4.500000   6.000000  -3.000000  12.000000   0.000000
   4.500000   6.000000   3.000000  12.000000   0.000000
EOF
paste output/zvo_phys.dat reference.dat > paste.dat
diff=`awk '
BEGIN{diff=0.0} 
NR>1{diff+=sqrt(($1-$6)*($1-$6))} 
END{printf "%8.6f", diff/NR}
' paste.dat`
test "${diff}" = "0.000000"

exit $?
