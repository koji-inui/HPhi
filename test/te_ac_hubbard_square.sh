#!/bin/sh -e

mkdir -p te_ac_hubbard_square/
cd te_ac_hubbard_square

cat > stan.in <<EOF
model = "Hubbard"
method = "lanczos"
lattice = "square"
a0w = 3
a0l = 0
a1w = 0
a1l = 3
t = 1.0
U = 10.0
nelec = 8
2Sz = 0
lanczos_max = 1000
initial_iv = 1
EigenvecIO = "out"
EOF

${MPIRUN} ../../src/HPhi -s stan.in

# Check value for Restart_in
cp ./stan.in stan1.in
sed -i -e "s/method = \"lanczos\"/method = \"Time-Evolution\"/g" stan1.in
sed -i -e "s/lanczos_max = 1000/lanczos_max = 40/g" stan1.in
sed -i -e "s/EigenvecIO = \"out\"/EigenvecIO = \"in\"/g" stan1.in
cat >> stan1.in <<EOF
dt = 0.01
tshift = 0.2
freq = 10.0
PumpType = "AC Laser"
VecPotW = 0.5
VecPotL = 0.5
EOF

${MPIRUN} ../../src/HPhi -s stan1.in

# Check value: Flct
cat > reference.dat <<EOF
0.0000000000000000 7.9999999999999973 63.9999999999999787 0.2592919779061983 0.2991789411194007 0.0000000000000000 0.0000000000000000 0
0.0100000000000000 7.9999999999999227 63.9999999999993818 0.2594015086710231 0.2993341079735412 0.0000000000000000 0.0000000000000000 1
0.0200000000000000 8.0000000000000053 64.0000000000000426 0.2597395675282361 0.2998121699932950 0.0000000000000000 0.0000000000000000 2
0.0300000000000000 7.9999999999999627 63.9999999999997016 0.2603310808494979 0.3006441585089782 0.0000000000000000 0.0000000000000000 3
0.0400000000000000 7.9999999999999689 63.9999999999997513 0.2611742667984473 0.3018229459408626 0.0000000000000000 0.0000000000000000 4
0.0500000000000000 7.9999999999999991 63.9999999999999929 0.2622397966226166 0.3033023414376818 0.0000000000000000 0.0000000000000000 5
0.0600000000000000 7.9999999999999023 63.9999999999992184 0.2634722119346927 0.3049992968516049 0.0000000000000000 0.0000000000000000 6
0.0700000000000000 7.9999999999999591 63.9999999999996732 0.2647935666240193 0.3067992034829383 0.0000000000000000 0.0000000000000000 7
0.0800000000000000 7.9999999999999583 63.9999999999996660 0.2661091303919663 0.3085641116783819 0.0000000000000000 0.0000000000000000 8
0.0900000000000000 7.9999999999999512 63.9999999999996092 0.2673148583662375 0.3101435289007348 0.0000000000000000 0.0000000000000000 9
0.1000000000000000 8.0000000000000249 64.0000000000001990 0.2683062008891974 0.3113872443366253 0.0000000000000000 0.0000000000000000 10
0.1100000000000000 8.0000000000000249 64.0000000000001990 0.2689877059494516 0.3121594019534892 0.0000000000000000 0.0000000000000000 11
0.1200000000000000 8.0000000000000000 64.0000000000000000 0.2692827643476592 0.3123528282319298 0.0000000000000000 0.0000000000000000 12
0.1300000000000000 7.9999999999999654 63.9999999999997229 0.2691427782659601 0.3119024575429984 0.0000000000000000 0.0000000000000000 13
0.1400000000000000 8.0000000000000053 64.0000000000000426 0.2685550122797003 0.3107966335176003 0.0000000000000000 0.0000000000000000 14
0.1500000000000000 8.0000000000000284 64.0000000000002274 0.2675484248600823 0.3090851370090753 0.0000000000000000 0.0000000000000000 15
0.1600000000000000 8.0000000000000302 64.0000000000002416 0.2661968853874476 0.3068830177868512 0.0000000000000000 0.0000000000000000 16
0.1700000000000000 8.0000000000000000 64.0000000000000000 0.2646193552965709 0.3043696749127084 0.0000000000000000 0.0000000000000000 17
0.1800000000000000 7.9999999999999618 63.9999999999996945 0.2629768404736829 0.3017830940371194 0.0000000000000000 0.0000000000000000 18
0.1900000000000000 8.0000000000000302 64.0000000000002416 0.2614661836295618 0.2994096370238267 0.0000000000000000 0.0000000000000000 19
0.2000000000000000 8.0000000000000213 64.0000000000001705 0.2603110309451283 0.2975702086633016 0.0000000000000000 0.0000000000000000 20
0.2100000000000000 8.0000000000000213 64.0000000000001705 0.2597505450158197 0.2966039251702082 0.0000000000000000 0.0000000000000000 21
0.2200000000000000 8.0000000000000018 64.0000000000000142 0.2600266171669736 0.2968505366396351 0.0000000000000000 0.0000000000000000 22
0.2300000000000000 7.9999999999999920 63.9999999999999361 0.2613704359614177 0.2986328066717865 0.0000000000000000 0.0000000000000000 23
0.2400000000000000 8.0000000000000639 64.0000000000005116 0.2639892863806777 0.3022398609843923 0.0000000000000000 0.0000000000000000 24
0.2500000000000000 8.0000000000000426 64.0000000000003411 0.2680543898899732 0.3079122432110107 0.0000000000000000 0.0000000000000000 25
0.2600000000000000 8.0000000000000764 64.0000000000006111 0.2736904650325477 0.3158291286240378 0.0000000000000000 0.0000000000000000 26
0.2700000000000000 7.9999999999999414 63.9999999999995310 0.2809675149426181 0.3260979041957944 0.0000000000000000 0.0000000000000000 27
0.2800000000000000 8.0000000000000853 64.0000000000006821 0.2898951591567855 0.3387461640133248 0.0000000000000000 0.0000000000000000 28
0.2900000000000000 7.9999999999999289 63.9999999999994316 0.3004196479122982 0.3537161056597998 0.0000000000000000 0.0000000000000000 29
0.3000000000000000 8.0000000000000053 64.0000000000000426 0.3124235480111997 0.3708613375659157 0.0000000000000000 0.0000000000000000 30
0.3100000000000000 8.0000000000001279 64.0000000000010232 0.3257279826034545 0.3899461969721081 0.0000000000000000 0.0000000000000000 31
0.3200000000000000 8.0000000000000142 64.0000000000001137 0.3400972460846945 0.4106478027974304 0.0000000000000000 0.0000000000000000 32
0.3300000000000000 7.9999999999999885 63.9999999999999076 0.3552455940799105 0.4325611936282339 0.0000000000000000 0.0000000000000000 33
0.3400000000000000 8.0000000000000107 64.0000000000000853 0.3708460143071892 0.4552079925842441 0.0000000000000000 0.0000000000000000 34
0.3500000000000000 8.0000000000000053 64.0000000000000426 0.3865407993812547 0.4780490612521249 0.0000000000000000 0.0000000000000000 35
0.3600000000000000 8.0000000000000124 64.0000000000000995 0.4019537481668881 0.5005015185136190 0.0000000000000000 0.0000000000000000 36
0.3700000000000000 7.9999999999999796 63.9999999999998366 0.4167038008288473 0.5219602774569393 0.0000000000000000 0.0000000000000000 37
0.3800000000000000 8.0000000000000107 64.0000000000000853 0.4304198520972792 0.5418238797598864 0.0000000000000000 0.0000000000000000 38
0.3900000000000000 8.0000000000000124 64.0000000000000995 0.4427563832523804 0.5595238918609435 0.0000000000000000 0.0000000000000000 39
EOF
sed -e "1d" output/Flct.dat > flct.dat
paste flct.dat reference.dat > paste1.dat
diff=`awk 'BEGIN{diff=0.0} {diff+=sqrt(($2-$10)*($2-$10))} END{printf "%8.6f", diff}' paste1.dat`
diff=`awk 'BEGIN{diff='${diff}'} {diff+=sqrt(($3-$11)*($3-$11))} END{printf "%8.6f", diff}' paste1.dat`
diff=`awk 'BEGIN{diff='${diff}'} {diff+=sqrt(($4-$12)*($4-$12))} END{printf "%8.6f", diff}' paste1.dat`
diff=`awk 'BEGIN{diff='${diff}'} {diff+=sqrt(($5-$13)*($5-$13))} END{printf "%8.6f", diff}' paste1.dat`
diff=`awk 'BEGIN{diff='${diff}'} {diff+=sqrt(($6-$14)*($6-$14))} END{printf "%8.6f", diff}' paste1.dat`
diff=`awk 'BEGIN{diff='${diff}'} {diff+=sqrt(($7-$15)*($7-$15))} END{printf "%8.6f", diff}' paste1.dat`

test "${diff}" = "0.000000"
exit $?