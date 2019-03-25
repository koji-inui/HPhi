#!/bin/sh -e

mkdir -p lobcg_genspin_ladder/
cd lobcg_genspin_ladder

cat > stan.in <<EOF
L = 3
W = 2
model = "Spin"
method = "CG"
lattice = "ladder"
J0 = 1.0
J1 = 1.0
D=0.2
2Sz = 0
2S = 3
exct = 2
EOF

${MPIRUN} ../../src/HPhi -s stan.in

# Check value

cat > reference.dat <<EOF
 0
  -17.4313533823121070
  0.0000000000000000
  0.0000000000000000

 1
  -16.5635711275654067
  0.0000000000000000
  0.0000000000000000
EOF
paste output/zvo_energy.dat reference.dat > paste1.dat
diff=`awk '
BEGIN{diff=0.0}
{diff+=sqrt(($2-$3)*($2-$3))}
END{printf "%8.6f", diff}
' paste1.dat`
echo "Diff output/zvo_energy.dat : " ${diff}
test "${diff}" = "0.000000"

# Check one-body G

cat > reference.dat <<EOF
   0.2156819194 0.0000000000
   0.2896804414 0.0000000000
   0.2735933588 0.0000000000
   0.2210442803 0.0000000000
   0.2156819194 0.0000000000
   0.2896804414 0.0000000000
   0.2735933588 0.0000000000
   0.2210442803 0.0000000000
EOF
paste output/zvo_cisajs_eigen0.dat reference.dat > paste2.dat
diff=`awk '
BEGIN{diff=0.0} 
{diff+=sqrt(($5-$7)*($5-$7)+($6-$8)*($6-$8))}
END{printf "%8.6f", diff/NR}
' paste2.dat`
echo "Diff output/zvo_cisajs_eigen0.dat : " ${diff}
test "${diff}" = "0.000000"

cat > reference.dat <<EOF
   0.1407449878 0.0000000000
   0.3738630667 0.0000000000
   0.3300390241 0.0000000000
   0.1553529214 0.0000000000
   0.1407450206 0.0000000000
   0.3738629976 0.0000000000
   0.3300389981 0.0000000000
   0.1553529837 0.0000000000
EOF
paste output/zvo_cisajs_eigen1.dat reference.dat > paste3.dat
diff=`awk '
BEGIN{diff=0.0} 
{diff+=sqrt(($5-$7)*($5-$7)+($6-$8)*($6-$8))}
END{printf "%8.6f", diff/NR}
' paste3.dat`
echo "Diff output/zvo_cisajs_eigen1.dat : " ${diff}
test "${diff}" = "0.000000"

# Check two-body G

cat > reference.dat <<EOF
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0006107495 0.0000000000
   0.0104503775 0.0000000000
   0.0415247481 0.0000000000
   0.1630960443 0.0000000000
   0.0104039691 0.0000000000
   0.0469727221 0.0000000000
   0.0773204721 0.0000000000
   0.0809847561 0.0000000000
   0.0716713758 0.0000000000
   0.0745511089 0.0000000000
   0.0483227136 0.0000000000
   0.0211367211 0.0000000000
   0.0104039691 0.0000000000
   0.0469727221 0.0000000000
   0.0773204721 0.0000000000
   0.0809847561 0.0000000000
   0.0716713758 0.0000000000
   0.0745511089 0.0000000000
   0.0483227136 0.0000000000
   0.0211367211 0.0000000000
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   -0.0099158135 -0.0000000000
   -0.0466371219 -0.0000000000
   -0.1492764677 -0.0000000000
   -0.0318171447 0.0000000000
   -0.0404986661 0.0000000000
   -0.0198770313 0.0000000000
   0.0206523668 -0.0000000000
   0.0304148252 -0.0000000000
   0.0244682241 0.0000000000
   -0.0318171447 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0198770313 -0.0000000000
   0.0206523668 0.0000000000
   0.0304148252 0.0000000000
   0.0244682241 -0.0000000000
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   0.0286535519 0.0000000000
   0.1148686576 0.0000000000
   -0.0052093340 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0070074929 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0052093340 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0070074929 0.0000000000
   -0.0039826763 0.0000000000
   0.2156819194 0.0000000000
   -0.0744110758 -0.0000000000
   0.0137311776 0.0000000000
   -0.0043868210 -0.0000000000
   0.0137311776 0.0000000000
   -0.0043868210 0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   -0.0099158135 0.0000000000
   -0.0466371219 0.0000000000
   -0.1492764677 0.0000000000
   -0.0318171447 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0198770313 -0.0000000000
   0.0206523668 0.0000000000
   0.0304148252 0.0000000000
   0.0244682241 -0.0000000000
   -0.0318171447 0.0000000000
   -0.0404986661 0.0000000000
   -0.0198770313 0.0000000000
   0.0206523668 -0.0000000000
   0.0304148252 -0.0000000000
   0.0244682241 0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0104503775 0.0000000000
   0.0628753214 0.0000000000
   0.1686863831 0.0000000000
   0.0476683595 0.0000000000
   0.0469727221 0.0000000000
   0.0788296299 0.0000000000
   0.0794940095 0.0000000000
   0.0843840799 0.0000000000
   0.0745511089 0.0000000000
   0.0868887445 0.0000000000
   0.0754852145 0.0000000000
   0.0527553735 0.0000000000
   0.0469727221 0.0000000000
   0.0788296299 0.0000000000
   0.0794940095 0.0000000000
   0.0843840799 0.0000000000
   0.0745511089 0.0000000000
   0.0868887445 0.0000000000
   0.0754852145 0.0000000000
   0.0527553735 0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   -0.0466371219 -0.0000000000
   -0.1547908939 -0.0000000000
   -0.0457733972 -0.0000000000
   -0.0404986661 0.0000000000
   -0.0416735834 -0.0000000000
   -0.0399968404 -0.0000000000
   0.0304148252 -0.0000000000
   0.0358985675 -0.0000000000
   0.0303176263 0.0000000000
   -0.0404986661 -0.0000000000
   -0.0416735834 -0.0000000000
   -0.0399968404 -0.0000000000
   0.0304148252 0.0000000000
   0.0358985675 0.0000000000
   0.0303176263 -0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   0.1148686576 0.0000000000
   0.0316246925 0.0000000000
   -0.0176404171 -0.0000000000
   -0.0061159522 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0077032185 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0061159522 0.0000000000
   -0.0039826763 0.0000000000
   -0.0077032185 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   0.0286535519 -0.0000000000
   0.1148686576 -0.0000000000
   -0.0052093340 0.0000000000
   -0.0176404171 0.0000000000
   -0.0070074929 0.0000000000
   -0.0039826763 0.0000000000
   -0.0052093340 0.0000000000
   -0.0176404171 0.0000000000
   -0.0070074929 -0.0000000000
   -0.0039826763 -0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   -0.0466371219 0.0000000000
   -0.1547908939 0.0000000000
   -0.0457733972 0.0000000000
   -0.0404986661 -0.0000000000
   -0.0416735834 0.0000000000
   -0.0399968404 0.0000000000
   0.0304148252 0.0000000000
   0.0358985675 0.0000000000
   0.0303176263 -0.0000000000
   -0.0404986661 0.0000000000
   -0.0416735834 0.0000000000
   -0.0399968404 0.0000000000
   0.0304148252 -0.0000000000
   0.0358985675 -0.0000000000
   0.0303176263 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   0.0415247481 0.0000000000
   0.1686863831 0.0000000000
   0.0537019186 0.0000000000
   0.0096803091 0.0000000000
   0.0773204721 0.0000000000
   0.0794940095 0.0000000000
   0.0715971592 0.0000000000
   0.0451817180 0.0000000000
   0.0483227136 0.0000000000
   0.0754852145 0.0000000000
   0.0780638065 0.0000000000
   0.0717216242 0.0000000000
   0.0773204721 0.0000000000
   0.0794940095 0.0000000000
   0.0715971592 0.0000000000
   0.0451817180 0.0000000000
   0.0483227136 0.0000000000
   0.0754852145 0.0000000000
   0.0780638065 0.0000000000
   0.0717216242 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   -0.1492764677 -0.0000000000
   -0.0457733972 -0.0000000000
   -0.0091331148 -0.0000000000
   -0.0198770313 -0.0000000000
   -0.0399968404 -0.0000000000
   -0.0299929848 -0.0000000000
   0.0244682241 0.0000000000
   0.0303176263 0.0000000000
   0.0195805304 0.0000000000
   -0.0198770313 0.0000000000
   -0.0399968404 -0.0000000000
   -0.0299929848 -0.0000000000
   0.0244682241 -0.0000000000
   0.0303176263 -0.0000000000
   0.0195805304 -0.0000000000
   0.2210442803 0.0000000000
   -0.0744110758 0.0000000000
   0.0137311776 -0.0000000000
   -0.0043868210 0.0000000000
   0.0137311776 -0.0000000000
   -0.0043868210 -0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   0.1148686576 -0.0000000000
   0.0316246925 -0.0000000000
   -0.0176404171 0.0000000000
   -0.0061159522 0.0000000000
   -0.0039826763 0.0000000000
   -0.0077032185 0.0000000000
   -0.0176404171 0.0000000000
   -0.0061159522 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0077032185 -0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   -0.1492764677 0.0000000000
   -0.0457733972 0.0000000000
   -0.0091331148 0.0000000000
   -0.0198770313 0.0000000000
   -0.0399968404 0.0000000000
   -0.0299929848 0.0000000000
   0.0244682241 -0.0000000000
   0.0303176263 -0.0000000000
   0.0195805304 -0.0000000000
   -0.0198770313 -0.0000000000
   -0.0399968404 0.0000000000
   -0.0299929848 0.0000000000
   0.0244682241 0.0000000000
   0.0303176263 0.0000000000
   0.0195805304 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   0.1630960443 0.0000000000
   0.0476683595 0.0000000000
   0.0096803091 0.0000000000
   0.0005995674 0.0000000000
   0.0809847561 0.0000000000
   0.0843840799 0.0000000000
   0.0451817180 0.0000000000
   0.0104937262 0.0000000000
   0.0211367211 0.0000000000
   0.0527553735 0.0000000000
   0.0717216242 0.0000000000
   0.0754305615 0.0000000000
   0.0809847561 0.0000000000
   0.0843840799 0.0000000000
   0.0451817180 0.0000000000
   0.0104937262 0.0000000000
   0.0211367211 0.0000000000
   0.0527553735 0.0000000000
   0.0717216242 0.0000000000
   0.0754305615 0.0000000000
   0.0006107495 0.0000000000
   0.0104503775 0.0000000000
   0.0415247481 0.0000000000
   0.1630960443 0.0000000000
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0716713758 0.0000000000
   0.0745511089 0.0000000000
   0.0483227136 0.0000000000
   0.0211367211 0.0000000000
   0.0104039691 0.0000000000
   0.0469727221 0.0000000000
   0.0773204721 0.0000000000
   0.0809847561 0.0000000000
   0.0716713758 0.0000000000
   0.0745511089 0.0000000000
   0.0483227136 0.0000000000
   0.0211367211 0.0000000000
   0.0104039691 0.0000000000
   0.0469727221 0.0000000000
   0.0773204721 0.0000000000
   0.0809847561 0.0000000000
   -0.0099158135 0.0000000000
   -0.0466371219 0.0000000000
   -0.1492764677 0.0000000000
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0206523668 0.0000000000
   0.0304148252 0.0000000000
   0.0244682241 0.0000000000
   -0.0318171447 0.0000000000
   -0.0404986661 0.0000000000
   -0.0198770313 -0.0000000000
   0.0206523668 -0.0000000000
   0.0304148252 0.0000000000
   0.0244682241 0.0000000000
   -0.0318171447 0.0000000000
   -0.0404986661 0.0000000000
   -0.0198770313 0.0000000000
   0.0286535519 -0.0000000000
   0.1148686576 -0.0000000000
   0.2156819194 0.0000000000
   0.0000000000 0.0000000000
   -0.0070074929 0.0000000000
   -0.0039826763 0.0000000000
   -0.0052093340 0.0000000000
   -0.0176404171 0.0000000000
   -0.0070074929 0.0000000000
   -0.0039826763 0.0000000000
   -0.0052093340 0.0000000000
   -0.0176404171 0.0000000000
   -0.0744110758 0.0000000000
   0.2156819194 0.0000000000
   -0.0043868210 0.0000000000
   0.0137311776 -0.0000000000
   -0.0043868210 0.0000000000
   0.0137311776 -0.0000000000
   -0.0099158135 -0.0000000000
   -0.0466371219 -0.0000000000
   -0.1492764677 -0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0206523668 -0.0000000000
   0.0304148252 -0.0000000000
   0.0244682241 -0.0000000000
   -0.0318171447 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0198770313 0.0000000000
   0.0206523668 0.0000000000
   0.0304148252 -0.0000000000
   0.0244682241 -0.0000000000
   -0.0318171447 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0198770313 -0.0000000000
   0.0104503775 0.0000000000
   0.0628753214 0.0000000000
   0.1686863831 0.0000000000
   0.0476683595 0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0745511089 0.0000000000
   0.0868887445 0.0000000000
   0.0754852145 0.0000000000
   0.0527553735 0.0000000000
   0.0469727221 0.0000000000
   0.0788296299 0.0000000000
   0.0794940095 0.0000000000
   0.0843840799 0.0000000000
   0.0745511089 0.0000000000
   0.0868887445 0.0000000000
   0.0754852145 0.0000000000
   0.0527553735 0.0000000000
   0.0469727221 0.0000000000
   0.0788296299 0.0000000000
   0.0794940095 0.0000000000
   0.0843840799 0.0000000000
   -0.0466371219 0.0000000000
   -0.1547908939 0.0000000000
   -0.0457733972 0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   0.0000000000 0.0000000000
   0.0304148252 -0.0000000000
   0.0358985675 -0.0000000000
   0.0303176263 0.0000000000
   -0.0404986661 0.0000000000
   -0.0416735834 0.0000000000
   -0.0399968404 0.0000000000
   0.0304148252 -0.0000000000
   0.0358985675 0.0000000000
   0.0303176263 0.0000000000
   -0.0404986661 0.0000000000
   -0.0416735834 0.0000000000
   -0.0399968404 0.0000000000
   0.1148686576 -0.0000000000
   0.0316246925 -0.0000000000
   0.0000000000 0.0000000000
   0.2896804414 0.0000000000
   -0.0039826763 -0.0000000000
   -0.0077032185 0.0000000000
   -0.0176404171 0.0000000000
   -0.0061159522 0.0000000000
   -0.0039826763 0.0000000000
   -0.0077032185 0.0000000000
   -0.0176404171 0.0000000000
   -0.0061159522 0.0000000000
   0.0286535519 0.0000000000
   0.1148686576 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   -0.0070074929 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0052093340 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0070074929 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0052093340 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0466371219 -0.0000000000
   -0.1547908939 -0.0000000000
   -0.0457733972 -0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   0.0304148252 0.0000000000
   0.0358985675 0.0000000000
   0.0303176263 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0416735834 -0.0000000000
   -0.0399968404 -0.0000000000
   0.0304148252 0.0000000000
   0.0358985675 -0.0000000000
   0.0303176263 -0.0000000000
   -0.0404986661 -0.0000000000
   -0.0416735834 -0.0000000000
   -0.0399968404 -0.0000000000
   0.0415247481 0.0000000000
   0.1686863831 0.0000000000
   0.0537019186 0.0000000000
   0.0096803091 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   0.0000000000 0.0000000000
   0.0483227136 0.0000000000
   0.0754852145 0.0000000000
   0.0780638065 0.0000000000
   0.0717216242 0.0000000000
   0.0773204721 0.0000000000
   0.0794940095 0.0000000000
   0.0715971592 0.0000000000
   0.0451817180 0.0000000000
   0.0483227136 0.0000000000
   0.0754852145 0.0000000000
   0.0780638065 0.0000000000
   0.0717216242 0.0000000000
   0.0773204721 0.0000000000
   0.0794940095 0.0000000000
   0.0715971592 0.0000000000
   0.0451817180 0.0000000000
   -0.1492764677 0.0000000000
   -0.0457733972 0.0000000000
   -0.0091331148 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2735933588 0.0000000000
   0.0244682241 -0.0000000000
   0.0303176263 -0.0000000000
   0.0195805304 -0.0000000000
   -0.0198770313 0.0000000000
   -0.0399968404 0.0000000000
   -0.0299929848 0.0000000000
   0.0244682241 -0.0000000000
   0.0303176263 0.0000000000
   0.0195805304 0.0000000000
   -0.0198770313 -0.0000000000
   -0.0399968404 0.0000000000
   -0.0299929848 0.0000000000
   -0.0744110758 -0.0000000000
   0.2210442803 0.0000000000
   -0.0043868210 -0.0000000000
   0.0137311776 0.0000000000
   -0.0043868210 -0.0000000000
   0.0137311776 0.0000000000
   0.1148686576 0.0000000000
   0.0316246925 0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   -0.0039826763 0.0000000000
   -0.0077032185 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0061159522 -0.0000000000
   -0.0039826763 -0.0000000000
   -0.0077032185 -0.0000000000
   -0.0176404171 -0.0000000000
   -0.0061159522 -0.0000000000
   -0.1492764677 -0.0000000000
   -0.0457733972 -0.0000000000
   -0.0091331148 -0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   0.0244682241 0.0000000000
   0.0303176263 0.0000000000
   0.0195805304 0.0000000000
   -0.0198770313 -0.0000000000
   -0.0399968404 -0.0000000000
   -0.0299929848 -0.0000000000
   0.0244682241 0.0000000000
   0.0303176263 -0.0000000000
   0.0195805304 -0.0000000000
   -0.0198770313 0.0000000000
   -0.0399968404 -0.0000000000
   -0.0299929848 -0.0000000000
   0.1630960443 0.0000000000
   0.0476683595 0.0000000000
   0.0096803091 0.0000000000
   0.0005995674 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.2210442803 0.0000000000
   0.0211367211 0.0000000000
   0.0527553735 0.0000000000
   0.0717216242 0.0000000000
   0.0754305615 0.0000000000
   0.0809847561 0.0000000000
   0.0843840799 0.0000000000
   0.0451817180 0.0000000000
   0.0104937262 0.0000000000
   0.0211367211 0.0000000000
   0.0527553735 0.0000000000
   0.0717216242 0.0000000000
   0.0754305615 0.0000000000
   0.0809847561 0.0000000000
   0.0843840799 0.0000000000
   0.0451817180 0.0000000000
   0.0104937262 0.0000000000
EOF
paste output/zvo_cisajscktalt_eigen0.dat reference.dat > paste5.dat
diff=`awk '
BEGIN{diff=0.0} 
{diff+=sqrt(($9-$11)*($9-$11)+($10-$12)*($10-$12))}
END{printf "%8.6f", diff/NR}
' paste5.dat`
echo "Diff output/zvo_cisajscktalt_eigen0.dat : " ${diff}
test "${diff}" = "0.000000"

cat > reference.dat <<EOF
   0.1407449878 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0010911139 0.0000000000
   0.0136777939 0.0000000000
   0.0821608846 0.0000000000
   0.0438151954 0.0000000000
   0.0056519724 0.0000000000
   0.0339581738 0.0000000000
   0.0552134897 0.0000000000
   0.0459213519 0.0000000000
   0.0208462416 0.0000000000
   0.0603614515 0.0000000000
   0.0424927048 0.0000000000
   0.0170445899 0.0000000000
   0.0056519644 0.0000000000
   0.0339581437 0.0000000000
   0.0552134869 0.0000000000
   0.0459213928 0.0000000000
   0.0208462372 0.0000000000
   0.0603614711 0.0000000000
   0.0424927042 0.0000000000
   0.0170445753 0.0000000000
   0.1407449878 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   -0.0128497781 0.0000000001
   -0.1018905694 0.0000000013
   -0.0692136460 0.0000000092
   -0.0143893256 0.0000000431
   -0.0416090663 0.0000001131
   -0.0372776188 0.0000001272
   0.0286845088 -0.0000001125
   0.0373667899 -0.0000000963
   0.0199912052 -0.0000000414
   -0.0143893386 -0.0000000183
   -0.0416091051 -0.0000001030
   -0.0372776640 -0.0000001586
   0.0286845218 0.0000001321
   0.0373668011 0.0000000846
   0.0199911967 0.0000000173
   0.1407449878 0.0000000000
   0.0000000000 0.0000000000
   0.0653708803 -0.0000000036
   0.0596102959 -0.0000000123
   -0.0182213965 -0.0000000411
   -0.0304560404 -0.0000000295
   -0.0163412689 -0.0000000185
   -0.0168168351 -0.0000000217
   -0.0182213625 0.0000000262
   -0.0304560171 0.0000000420
   -0.0163412681 0.0000000271
   -0.0168168304 0.0000000162
   0.1407449878 0.0000000000
   -0.0277717755 0.0000000083
   0.0238349710 -0.0000000019
   -0.0093526651 0.0000000017
   0.0238349797 -0.0000000032
   -0.0093526649 0.0000000028
   0.3738630667 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   -0.0128497781 -0.0000000001
   -0.1018905694 -0.0000000013
   -0.0692136460 -0.0000000092
   -0.0143893256 -0.0000000431
   -0.0416090663 -0.0000001131
   -0.0372776188 -0.0000001272
   0.0286845088 0.0000001125
   0.0373667899 0.0000000963
   0.0199912052 0.0000000414
   -0.0143893386 0.0000000183
   -0.0416091051 0.0000001030
   -0.0372776640 0.0000001586
   0.0286845218 -0.0000001321
   0.0373668011 -0.0000000846
   0.0199911967 -0.0000000173
   0.0000000000 0.0000000000
   0.3738630667 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0136777972 0.0000000000
   0.1418781927 0.0000000000
   0.1214592847 0.0000000000
   0.0968477921 0.0000000000
   0.0339581817 0.0000000000
   0.1292629546 0.0000000000
   0.1400005469 0.0000000000
   0.0706413835 0.0000000000
   0.0603614575 0.0000000000
   0.1440212129 0.0000000000
   0.1158684062 0.0000000000
   0.0536119900 0.0000000000
   0.0339581676 0.0000000000
   0.1292629312 0.0000000000
   0.1400005651 0.0000000000
   0.0706414027 0.0000000000
   0.0603614522 0.0000000000
   0.1440212506 0.0000000000
   0.1158684112 0.0000000000
   0.0536119527 0.0000000000
   0.0000000000 0.0000000000
   0.3738630667 0.0000000000
   0.0000000000 0.0000000000
   -0.1018905926 0.0000000040
   -0.1155784434 0.0000000088
   -0.0982343503 0.0000000078
   -0.0416090523 -0.0000000100
   -0.0656587648 -0.0000000048
   -0.0390684132 0.0000000049
   0.0373667869 -0.0000000222
   0.0572950892 0.0000000006
   0.0360919072 0.0000000215
   -0.0416090882 0.0000000564
   -0.0656588119 0.0000000060
   -0.0390684447 -0.0000000450
   0.0373667972 0.0000000454
   0.0572951049 -0.0000000071
   0.0360919021 -0.0000000569
   0.0000000000 0.0000000000
   0.3738630667 0.0000000000
   0.0596102944 -0.0000000100
   0.0762247536 -0.0000000174
   -0.0304560426 0.0000000323
   -0.0282046458 0.0000000494
   -0.0168168351 0.0000000216
   -0.0227264915 0.0000000212
   -0.0304560094 -0.0000000275
   -0.0282046145 -0.0000000168
   -0.0168168331 -0.0000000076
   -0.0227264788 -0.0000000164
   0.3300390241 0.0000000000
   0.0000000000 0.0000000000
   0.0653708803 0.0000000036
   0.0596102959 0.0000000123
   -0.0182213965 0.0000000411
   -0.0304560404 0.0000000295
   -0.0163412689 0.0000000185
   -0.0168168351 0.0000000217
   -0.0182213625 -0.0000000262
   -0.0304560171 -0.0000000420
   -0.0163412681 -0.0000000271
   -0.0168168304 -0.0000000162
   0.0000000000 0.0000000000
   0.3300390241 0.0000000000
   0.0000000000 0.0000000000
   -0.1018905926 -0.0000000040
   -0.1155784434 -0.0000000088
   -0.0982343503 -0.0000000078
   -0.0416090523 0.0000000100
   -0.0656587648 0.0000000048
   -0.0390684132 -0.0000000049
   0.0373667869 0.0000000222
   0.0572950892 -0.0000000006
   0.0360919072 -0.0000000215
   -0.0416090882 -0.0000000564
   -0.0656588119 -0.0000000060
   -0.0390684447 0.0000000450
   0.0373667972 -0.0000000454
   0.0572951049 0.0000000071
   0.0360919021 0.0000000569
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.3300390241 0.0000000000
   0.0000000000 0.0000000000
   0.0821609206 0.0000000000
   0.1214592720 0.0000000000
   0.1130068724 0.0000000000
   0.0134119591 0.0000000000
   0.0552134885 0.0000000000
   0.1400005607 0.0000000000
   0.1013390558 0.0000000000
   0.0334859192 0.0000000000
   0.0424926912 0.0000000000
   0.1158683735 0.0000000000
   0.1127565215 0.0000000000
   0.0589214379 0.0000000000
   0.0552134810 0.0000000000
   0.1400005415 0.0000000000
   0.1013390714 0.0000000000
   0.0334859302 0.0000000000
   0.0424926956 0.0000000000
   0.1158684088 0.0000000000
   0.1127565284 0.0000000000
   0.0589213914 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.3300390241 0.0000000000
   -0.0692136373 0.0000000066
   -0.0982343225 0.0000000139
   -0.0125239492 0.0000000012
   -0.0372775953 -0.0000001281
   -0.0390683873 -0.0000001162
   -0.0181399734 -0.0000000394
   0.0199911832 0.0000000396
   0.0360918772 0.0000000945
   0.0292475827 0.0000001054
   -0.0372776596 0.0000001615
   -0.0390684482 0.0000001053
   -0.0181399912 0.0000000240
   0.0199911962 -0.0000000244
   0.0360919049 -0.0000000941
   0.0292475978 -0.0000001375
   0.1553529214 0.0000000000
   -0.0277717755 -0.0000000083
   0.0238349710 0.0000000019
   -0.0093526651 -0.0000000017
   0.0238349797 0.0000000032
   -0.0093526649 -0.0000000028
   0.0000000000 0.0000000000
   0.1553529214 0.0000000000
   0.0596102944 0.0000000100
   0.0762247536 0.0000000174
   -0.0304560426 -0.0000000323
   -0.0282046458 -0.0000000494
   -0.0168168351 -0.0000000216
   -0.0227264915 -0.0000000212
   -0.0304560094 0.0000000275
   -0.0282046145 0.0000000168
   -0.0168168331 0.0000000076
   -0.0227264788 0.0000000164
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.1553529214 0.0000000000
   -0.0692136373 -0.0000000066
   -0.0982343225 -0.0000000139
   -0.0125239492 -0.0000000012
   -0.0372775953 0.0000001281
   -0.0390683873 0.0000001162
   -0.0181399734 0.0000000394
   0.0199911832 -0.0000000396
   0.0360918772 -0.0000000945
   0.0292475827 -0.0000001054
   -0.0372776596 -0.0000001615
   -0.0390684482 -0.0000001053
   -0.0181399912 -0.0000000240
   0.0199911962 0.0000000244
   0.0360919049 0.0000000941
   0.0292475978 0.0000001375
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.1553529214 0.0000000000
   0.0438151890 0.0000000000
   0.0968477389 0.0000000000
   0.0134119564 0.0000000000
   0.0012780371 0.0000000000
   0.0459213213 0.0000000000
   0.0706413715 0.0000000000
   0.0334859204 0.0000000000
   0.0053043082 0.0000000000
   0.0170445697 0.0000000000
   0.0536119284 0.0000000000
   0.0589213760 0.0000000000
   0.0257750473 0.0000000000
   0.0459213690 0.0000000000
   0.0706413557 0.0000000000
   0.0334858962 0.0000000000
   0.0053043005 0.0000000000
   0.0170445736 0.0000000000
   0.0536119505 0.0000000000
   0.0589213857 0.0000000000
   0.0257750116 0.0000000000
   0.0010911139 0.0000000000
   0.0136777972 0.0000000000
   0.0821609206 0.0000000000
   0.0438151890 0.0000000000
   0.1407450206 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0208462454 0.0000000000
   0.0603614825 0.0000000000
   0.0424927100 0.0000000000
   0.0170445827 0.0000000000
   0.0056519583 0.0000000000
   0.0339581412 0.0000000000
   0.0552134913 0.0000000000
   0.0459214298 0.0000000000
   0.0208462607 0.0000000000
   0.0603614566 0.0000000000
   0.0424927086 0.0000000000
   0.0170445948 0.0000000000
   0.0056519701 0.0000000000
   0.0339581951 0.0000000000
   0.0552135029 0.0000000000
   0.0459213525 0.0000000000
   -0.0128497781 -0.0000000001
   -0.1018905926 -0.0000000040
   -0.0692136373 -0.0000000066
   0.1407450206 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0286845126 0.0000001153
   0.0373667940 0.0000001013
   0.0199911959 0.0000000397
   -0.0143893468 -0.0000000442
   -0.0416091292 -0.0000001216
   -0.0372776964 -0.0000001256
   0.0286844819 -0.0000001421
   0.0373667637 -0.0000000939
   0.0199911853 -0.0000000186
   -0.0143893336 0.0000000230
   -0.0416090708 0.0000001080
   -0.0372776185 0.0000001583
   0.0653708803 0.0000000036
   0.0596102944 0.0000000100
   0.1407450206 0.0000000000
   0.0000000000 0.0000000000
   -0.0163412773 0.0000000151
   -0.0168168403 0.0000000168
   -0.0182213457 0.0000000348
   -0.0304560046 0.0000000204
   -0.0163412822 -0.0000000227
   -0.0168168546 -0.0000000094
   -0.0182213875 -0.0000000180
   -0.0304560313 -0.0000000265
   -0.0277717755 -0.0000000083
   0.1407450206 0.0000000000
   -0.0093526670 -0.0000000023
   0.0238349855 0.0000000021
   -0.0093526667 -0.0000000001
   0.0238349761 -0.0000000040
   -0.0128497781 0.0000000001
   -0.1018905926 0.0000000040
   -0.0692136373 0.0000000066
   0.3738629976 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0286845126 -0.0000001153
   0.0373667940 -0.0000001013
   0.0199911959 -0.0000000397
   -0.0143893468 0.0000000442
   -0.0416091292 0.0000001216
   -0.0372776964 0.0000001256
   0.0286844819 0.0000001421
   0.0373667637 0.0000000939
   0.0199911853 0.0000000186
   -0.0143893336 -0.0000000230
   -0.0416090708 -0.0000001080
   -0.0372776185 -0.0000001583
   0.0136777939 0.0000000000
   0.1418781927 0.0000000000
   0.1214592720 0.0000000000
   0.0968477389 0.0000000000
   0.0000000000 0.0000000000
   0.3738629976 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0603614431 0.0000000000
   0.1440212241 0.0000000000
   0.1158683812 0.0000000000
   0.0536119492 0.0000000000
   0.0339581406 0.0000000000
   0.1292629174 0.0000000000
   0.1400005346 0.0000000000
   0.0706414049 0.0000000000
   0.0603614464 0.0000000000
   0.1440211885 0.0000000000
   0.1158683888 0.0000000000
   0.0536119738 0.0000000000
   0.0339581534 0.0000000000
   0.1292629474 0.0000000000
   0.1400005340 0.0000000000
   0.0706413629 0.0000000000
   -0.1018905694 -0.0000000013
   -0.1155784434 -0.0000000088
   -0.0982343225 -0.0000000139
   0.0000000000 0.0000000000
   0.3738629976 0.0000000000
   0.0000000000 0.0000000000
   0.0373667740 0.0000000218
   0.0572950775 0.0000000049
   0.0360918850 -0.0000000184
   -0.0416091047 0.0000000125
   -0.0656588196 -0.0000000010
   -0.0390684759 -0.0000000060
   0.0373667688 -0.0000000526
   0.0572950680 0.0000000032
   0.0360918766 0.0000000536
   -0.0416090781 -0.0000000524
   -0.0656587766 -0.0000000018
   -0.0390684256 0.0000000472
   0.0596102959 0.0000000123
   0.0762247536 0.0000000174
   0.0000000000 0.0000000000
   0.3738629976 0.0000000000
   -0.0168168432 -0.0000000237
   -0.0227264928 -0.0000000256
   -0.0304560009 -0.0000000350
   -0.0282045956 -0.0000000522
   -0.0168168462 0.0000000123
   -0.0227265061 0.0000000247
   -0.0304560414 0.0000000385
   -0.0282046275 0.0000000308
   0.0653708803 -0.0000000036
   0.0596102944 -0.0000000100
   0.3300389981 0.0000000000
   0.0000000000 0.0000000000
   -0.0163412773 -0.0000000151
   -0.0168168403 -0.0000000168
   -0.0182213457 -0.0000000348
   -0.0304560046 -0.0000000204
   -0.0163412822 0.0000000227
   -0.0168168546 0.0000000094
   -0.0182213875 0.0000000180
   -0.0304560313 0.0000000265
   -0.1018905694 0.0000000013
   -0.1155784434 0.0000000088
   -0.0982343225 0.0000000139
   0.0000000000 0.0000000000
   0.3300389981 0.0000000000
   0.0000000000 0.0000000000
   0.0373667740 -0.0000000218
   0.0572950775 -0.0000000049
   0.0360918850 0.0000000184
   -0.0416091047 -0.0000000125
   -0.0656588196 0.0000000010
   -0.0390684759 0.0000000060
   0.0373667688 0.0000000526
   0.0572950680 -0.0000000032
   0.0360918766 -0.0000000536
   -0.0416090781 0.0000000524
   -0.0656587766 0.0000000018
   -0.0390684256 -0.0000000472
   0.0821608846 0.0000000000
   0.1214592847 0.0000000000
   0.1130068724 0.0000000000
   0.0134119564 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.3300389981 0.0000000000
   0.0000000000 0.0000000000
   0.0424926958 0.0000000000
   0.1158683965 0.0000000000
   0.1127565147 0.0000000000
   0.0589213912 0.0000000000
   0.0552134747 0.0000000000
   0.1400005337 0.0000000000
   0.1013390642 0.0000000000
   0.0334859256 0.0000000000
   0.0424926923 0.0000000000
   0.1158683725 0.0000000000
   0.1127565203 0.0000000000
   0.0589214130 0.0000000000
   0.0552134801 0.0000000000
   0.1400005476 0.0000000000
   0.1013390609 0.0000000000
   0.0334859095 0.0000000000
   -0.0692136460 -0.0000000092
   -0.0982343503 -0.0000000078
   -0.0125239492 -0.0000000012
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.3300389981 0.0000000000
   0.0199911888 -0.0000000357
   0.0360918867 -0.0000000831
   0.0292475806 -0.0000000999
   -0.0372776683 0.0000001304
   -0.0390684556 0.0000001055
   -0.0181400106 0.0000000337
   0.0199911879 0.0000000182
   0.0360918823 0.0000000857
   0.0292475691 0.0000001300
   -0.0372776197 -0.0000001537
   -0.0390684204 -0.0000000963
   -0.0181399880 -0.0000000165
   -0.0277717755 0.0000000083
   0.1553529837 0.0000000000
   -0.0093526670 0.0000000023
   0.0238349855 -0.0000000021
   -0.0093526667 0.0000000001
   0.0238349761 0.0000000040
   0.0596102959 -0.0000000123
   0.0762247536 -0.0000000174
   0.0000000000 0.0000000000
   0.1553529837 0.0000000000
   -0.0168168432 0.0000000237
   -0.0227264928 0.0000000256
   -0.0304560009 0.0000000350
   -0.0282045956 0.0000000522
   -0.0168168462 -0.0000000123
   -0.0227265061 -0.0000000247
   -0.0304560414 -0.0000000385
   -0.0282046275 -0.0000000308
   -0.0692136460 0.0000000092
   -0.0982343503 0.0000000078
   -0.0125239492 0.0000000012
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.1553529837 0.0000000000
   0.0199911888 0.0000000357
   0.0360918867 0.0000000831
   0.0292475806 0.0000000999
   -0.0372776683 -0.0000001304
   -0.0390684556 -0.0000001055
   -0.0181400106 -0.0000000337
   0.0199911879 -0.0000000182
   0.0360918823 -0.0000000857
   0.0292475691 -0.0000001300
   -0.0372776197 0.0000001537
   -0.0390684204 0.0000000963
   -0.0181399880 0.0000000165
   0.0438151954 0.0000000000
   0.0968477921 0.0000000000
   0.0134119591 0.0000000000
   0.0012780371 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.0000000000 0.0000000000
   0.1553529837 0.0000000000
   0.0170445794 0.0000000000
   0.0536119576 0.0000000000
   0.0589214069 0.0000000000
   0.0257750397 0.0000000000
   0.0459213864 0.0000000000
   0.0706413739 0.0000000000
   0.0334859184 0.0000000000
   0.0053043049 0.0000000000
   0.0170445828 0.0000000000
   0.0536119545 0.0000000000
   0.0589214019 0.0000000000
   0.0257750446 0.0000000000
   0.0459213550 0.0000000000
   0.0706413909 0.0000000000
   0.0334859316 0.0000000000
   0.0053043062 0.0000000000
EOF
paste output/zvo_cisajscktalt_eigen1.dat reference.dat > paste6.dat
diff=`awk '
BEGIN{diff=0.0} 
{diff+=sqrt(($9-$11)*($9-$11)+($10-$12)*($10-$12))}
END{printf "%8.6f", diff/NR}
' paste6.dat`
echo "Diff output/zvo_cisajscktalt_eigen1.dat : " ${diff}
test "${diff}" = "0.000000"

exit $?
