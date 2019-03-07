/* HPhi  -  Quantum Lattice Model Simulator */
/* Copyright (C) 2015 The University of Tokyo */

/* This program is free software: you can redistribute it and/or modify */
/* it under the terms of the GNU General Public License as published by */
/* the Free Software Foundation, either version 3 of the License, or */
/* (at your option) any later version. */

/* This program is distributed in the hope that it will be useful, */
/* but WITHOUT ANY WARRANTY; without even the implied warranty of */
/* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the */
/* GNU General Public License for more details. */

/* You should have received a copy of the GNU General Public License */
/* along with this program.  If not, see <http://www.gnu.org/licenses/>. */

#include "bitcalc.h"
#include "mltplyCommon.h"
#include "mltply.h"
#include "expec_energy_flct.h"
#include "wrapperMPI.h"
#include "CalcTime.h"
#include "common/setmemory.h"
///
/// \brief Calculate expected values of energies and physical quantities for Hubbard GC model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_HubbardGC(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  long unsigned int is1_up_a, is1_up_b;
  long unsigned int is1_down_a, is1_down_b;
  int bit_up, bit_down, bit_D, istate;
  long unsigned int ibit_up, ibit_down, ibit_D;
  double D, tmp_D, tmp_D2;
  double N, tmp_N, tmp_N2;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max;
  unsigned int l_ibit1, u_ibit1, i_32;
  i_max = X->Check.idim_max;

  tmp_v02 = d_1d_allocate(nstate);
  i_32 = 0xFFFFFFFF; //2^32 - 1
    // tentative doublon
  tmp_D = 0.0;
  tmp_D2 = 0.0;
  tmp_N = 0.0;
  tmp_N2 = 0.0;
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

  //[s] for bit count
  is1_up_a = 0;
  is1_up_b = 0;
  is1_down_a = 0;
  is1_down_b = 0;
  for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
    if (isite1 > X->Def.Nsite) {
      is1_up_a += X->Def.Tpow[2 * isite1 - 2];
      is1_down_a += X->Def.Tpow[2 * isite1 - 1];
    }
    else {
      is1_up_b += X->Def.Tpow[2 * isite1 - 2];
      is1_down_b += X->Def.Tpow[2 * isite1 - 1];
    }
  }
  //[e]
#pragma omp parallel for reduction(+:tmp_D,tmp_D2,tmp_N,tmp_N2,tmp_Sz,tmp_Sz2) default(none) shared(v0,list_1) \
  firstprivate(i_max, X,myrank,is1_up_a,is1_down_a,is1_up_b,is1_down_b,i_32) \
  private(j, tmp_v02,D,N,Sz,isite1,bit_up,bit_down,bit_D,u_ibit1,l_ibit1,ibit_up,ibit_down,ibit_D)
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    bit_up = 0;
    bit_down = 0;
    bit_D = 0;
    // isite1 > X->Def.Nsite
    ibit_up = (unsigned long int) myrank & is1_up_a;
    u_ibit1 = ibit_up >> 32;
    l_ibit1 = ibit_up & i_32;
    bit_up += pop(u_ibit1);
    bit_up += pop(l_ibit1);

    ibit_down = (unsigned long int) myrank & is1_down_a;
    u_ibit1 = ibit_down >> 32;
    l_ibit1 = ibit_down & i_32;
    bit_down += pop(u_ibit1);
    bit_down += pop(l_ibit1);

    ibit_D = (ibit_up) & (ibit_down >> 1);
    u_ibit1 = ibit_D >> 32;
    l_ibit1 = ibit_D & i_32;
    bit_D += pop(u_ibit1);
    bit_D += pop(l_ibit1);

    // isite1 <= X->Def.Nsite
    ibit_up = (unsigned long int) (j - 1) & is1_up_b;
    u_ibit1 = ibit_up >> 32;
    l_ibit1 = ibit_up & i_32;
    bit_up += pop(u_ibit1);
    bit_up += pop(l_ibit1);

    ibit_down = (unsigned long int) (j - 1) & is1_down_b;
    u_ibit1 = ibit_down >> 32;
    l_ibit1 = ibit_down & i_32;
    bit_down += pop(u_ibit1);
    bit_down += pop(l_ibit1);

    ibit_D = (ibit_up) & (ibit_down >> 1);
    u_ibit1 = ibit_D >> 32;
    l_ibit1 = ibit_D & i_32;
    bit_D += pop(u_ibit1);
    bit_D += pop(l_ibit1);

    D = bit_D;
    N = bit_up + bit_down;
    Sz = bit_up - bit_down;

    for (istate = 0; istate < nstate; istate++) {
      X->Phys.doublon[istate] += tmp_v02[istate] * D;
      X->Phys.doublon2[istate] += tmp_v02[istate] * D * D;
      X->Phys.num[istate] += tmp_v02[istate] * N;
      X->Phys.num2[istate] += tmp_v02[istate] * N * N;
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.doublon);
  SumMPI_dv(nstate, X->Phys.doublon2);
  SumMPI_dv(nstate, X->Phys.num);
  SumMPI_dv(nstate, X->Phys.num2);
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
///
/// \brief Calculate expected values of energies and physical quantities for Hubbard model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_Hubbard(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  long unsigned int is1_up_a, is1_up_b;
  long unsigned int is1_down_a, is1_down_b;
  int bit_up, bit_down, bit_D, istate;

  long unsigned int ibit_up, ibit_down, ibit_D;
  double D, tmp_D, tmp_D2;
  double N, tmp_N, tmp_N2;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max, tmp_list_1;
  unsigned int l_ibit1, u_ibit1, i_32;
  i_max = X->Check.idim_max;

  tmp_v02 = d_1d_allocate(nstate);
  i_32 = (unsigned int)(pow(2, 32) - 1);

  tmp_D = 0.0;
  tmp_D2 = 0.0;
  tmp_N = 0.0;
  tmp_N2 = 0.0;
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

  //[s] for bit count
  is1_up_a = 0;
  is1_up_b = 0;
  is1_down_a = 0;
  is1_down_b = 0;
  for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
    if (isite1 > X->Def.Nsite) {
      is1_up_a += X->Def.Tpow[2 * isite1 - 2];
      is1_down_a += X->Def.Tpow[2 * isite1 - 1];
    }
    else {
      is1_up_b += X->Def.Tpow[2 * isite1 - 2];
      is1_down_b += X->Def.Tpow[2 * isite1 - 1];
    }
  }
  //[e]
#pragma omp parallel for reduction(+:tmp_D,tmp_D2,tmp_N,tmp_N2,tmp_Sz,tmp_Sz2) default(none) shared(v0,list_1) \
  firstprivate(i_max, X,myrank,is1_up_a,is1_down_a,is1_up_b,is1_down_b,i_32) \
  private(j, tmp_v02,D,N,Sz,isite1,tmp_list_1,bit_up,bit_down,bit_D,u_ibit1,l_ibit1,ibit_up,ibit_down,ibit_D)
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    bit_up = 0;
    bit_down = 0;
    bit_D = 0;
    tmp_list_1 = list_1[j];
    // isite1 > X->Def.Nsite
    ibit_up = (unsigned long int) myrank & is1_up_a;
    u_ibit1 = ibit_up >> 32;
    l_ibit1 = ibit_up & i_32;
    bit_up += pop(u_ibit1);
    bit_up += pop(l_ibit1);

    ibit_down = (unsigned long int) myrank & is1_down_a;
    u_ibit1 = ibit_down >> 32;
    l_ibit1 = ibit_down & i_32;
    bit_down += pop(u_ibit1);
    bit_down += pop(l_ibit1);

    ibit_D = (ibit_up) & (ibit_down >> 1);
    u_ibit1 = ibit_D >> 32;
    l_ibit1 = ibit_D & i_32;
    bit_D += pop(u_ibit1);
    bit_D += pop(l_ibit1);

    // isite1 <= X->Def.Nsite
    ibit_up = (unsigned long int) tmp_list_1 & is1_up_b;
    u_ibit1 = ibit_up >> 32;
    l_ibit1 = ibit_up & i_32;
    bit_up += pop(u_ibit1);
    bit_up += pop(l_ibit1);

    ibit_down = (unsigned long int) tmp_list_1 & is1_down_b;
    u_ibit1 = ibit_down >> 32;
    l_ibit1 = ibit_down & i_32;
    bit_down += pop(u_ibit1);
    bit_down += pop(l_ibit1);

    ibit_D = (ibit_up) & (ibit_down >> 1);
    u_ibit1 = ibit_D >> 32;
    l_ibit1 = ibit_D & i_32;
    bit_D += pop(u_ibit1);
    bit_D += pop(l_ibit1);

    D = bit_D;
    N = bit_up + bit_down;
    Sz = bit_up - bit_down;

    for (istate = 0; istate < nstate; istate++) {
      X->Phys.doublon[istate] += tmp_v02[istate] * D;
      X->Phys.doublon2[istate] += tmp_v02[istate] * D * D;
      X->Phys.num[istate] += tmp_v02[istate] * N;
      X->Phys.num2[istate] += tmp_v02[istate] * N * N;
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.doublon);
  SumMPI_dv(nstate, X->Phys.doublon2);
  SumMPI_dv(nstate, X->Phys.num);
  SumMPI_dv(nstate, X->Phys.num2);
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
///
/// \brief Calculate expected values of energies and physical quantities for Half-SpinGC model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_HalfSpinGC(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  long unsigned int is1_up_a, is1_up_b;

  long unsigned int ibit1;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max;
  unsigned int l_ibit1, u_ibit1, i_32;
  int istate;

  i_max = X->Check.idim_max;

  tmp_v02 = d_1d_allocate(nstate);
  i_32 = 0xFFFFFFFF; //2^32 - 1

  // tentative doublon
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

  //[s] for bit count
  is1_up_a = 0;
  is1_up_b = 0;
  for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
    if (isite1 > X->Def.Nsite) {
      is1_up_a += X->Def.Tpow[isite1 - 1];
    }
    else {
      is1_up_b += X->Def.Tpow[isite1 - 1];
    }
  }
  //[e]
#pragma omp parallel for reduction(+:tmp_Sz,tmp_Sz2)default(none) shared(v0)   \
  firstprivate(i_max,X,myrank,i_32,is1_up_a,is1_up_b) private(j,Sz,ibit1,isite1,tmp_v02,u_ibit1,l_ibit1)
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    Sz = 0.0;

    // isite1 > X->Def.Nsite
    ibit1 = (unsigned long int) myrank & is1_up_a;
    u_ibit1 = ibit1 >> 32;
    l_ibit1 = ibit1 & i_32;
    Sz += pop(u_ibit1);
    Sz += pop(l_ibit1);
    // isite1 <= X->Def.Nsite
    ibit1 = (unsigned long int) (j - 1)&is1_up_b;
    u_ibit1 = ibit1 >> 32;
    l_ibit1 = ibit1 & i_32;
    Sz += pop(u_ibit1);
    Sz += pop(l_ibit1);
    Sz = 2 * Sz - X->Def.NsiteMPI;

    for (istate = 0; istate < nstate; istate++) {
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.doublon[istate] = 0.0;
    X->Phys.doublon2[istate] = 0.0;
    X->Phys.num[istate] = X->Def.NsiteMPI;
    X->Phys.num2[istate] = X->Def.NsiteMPI*X->Def.NsiteMPI;
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
///
/// \brief Calculate expected values of energies and physical quantities for General-SpinGC model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_GeneralSpinGC(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  int istate;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max;

  tmp_v02 = d_1d_allocate(nstate);
  i_max = X->Check.idim_max;

  // tentative doublon
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    Sz = 0.0;
    for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
      //prefactor 0.5 is added later.
      if (isite1 > X->Def.Nsite) {
        Sz += GetLocal2Sz(isite1, myrank, X->Def.SiteToBit, X->Def.Tpow);
      }
      else {
        Sz += GetLocal2Sz(isite1, j - 1, X->Def.SiteToBit, X->Def.Tpow);
      }
    }
    for (istate = 0; istate < nstate; istate++) {
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.doublon[istate] = 0.0;
    X->Phys.doublon2[istate] = 0.0;
    X->Phys.num[istate] = X->Def.NsiteMPI;
    X->Phys.num2[istate] = X->Def.NsiteMPI*X->Def.NsiteMPI;
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
///
/// \brief Calculate expected values of energies and physical quantities for Half-Spin model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_HalfSpin(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  long unsigned int is1_up_a, is1_up_b;

  long unsigned int ibit1;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max, tmp_list_1;
  unsigned int l_ibit1, u_ibit1, i_32;
  int istate;

  i_max = X->Check.idim_max;
  tmp_v02 = d_1d_allocate(nstate);
  i_32 = 0xFFFFFFFF; //2^32 - 1

  // tentative doublon
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

  //[s] for bit count
  is1_up_a = 0;
  is1_up_b = 0;
  for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
    if (isite1 > X->Def.Nsite) {
      is1_up_a += X->Def.Tpow[isite1 - 1];
    }
    else {
      is1_up_b += X->Def.Tpow[isite1 - 1];
    }
  }
  //[e]
#pragma omp parallel for reduction(+:tmp_Sz,tmp_Sz2)default(none) shared(v0, list_1)   \
  firstprivate(i_max,X,myrank,i_32,is1_up_a,is1_up_b) private(j,Sz,ibit1,isite1,tmp_v02,u_ibit1,l_ibit1, tmp_list_1)
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    Sz = 0.0;
    tmp_list_1 = list_1[j];

    // isite1 > X->Def.Nsite
    ibit1 = (unsigned long int) myrank & is1_up_a;
    u_ibit1 = ibit1 >> 32;
    l_ibit1 = ibit1 & i_32;
    Sz += pop(u_ibit1);
    Sz += pop(l_ibit1);
    // isite1 <= X->Def.Nsite
    ibit1 = (unsigned long int) tmp_list_1 &is1_up_b;
    u_ibit1 = ibit1 >> 32;
    l_ibit1 = ibit1 & i_32;
    Sz += pop(u_ibit1);
    Sz += pop(l_ibit1);
    Sz = 2 * Sz - X->Def.NsiteMPI;

    for (istate = 0; istate < nstate; istate++) {
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.doublon[istate] = 0.0;
    X->Phys.doublon2[istate] = 0.0;
    X->Phys.num[istate] = X->Def.NsiteMPI;
    X->Phys.num2[istate] = X->Def.NsiteMPI*X->Def.NsiteMPI;
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
///
/// \brief Calculate expected values of energies and physical quantities for General-Spin model
/// \param X [in, out] X Struct to get information about file header names, dimension of hirbert space, calc type and output physical quantities.
/// \retval 0 normally finished.
/// \retval -1 abnormally finished.
int expec_energy_flct_GeneralSpin(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0
) {
  long unsigned int j;
  long unsigned int isite1;
  int istate;
  double Sz, tmp_Sz, tmp_Sz2;
  double *tmp_v02;
  long unsigned int i_max, tmp_list1;

  tmp_v02 = d_1d_allocate(nstate);
  i_max = X->Check.idim_max;

  // tentative doublon
  tmp_Sz = 0.0;
  tmp_Sz2 = 0.0;

#pragma omp parallel for reduction(+:tmp_Sz,tmp_Sz2)default(none) shared(v0, list_1)   \
  firstprivate(i_max,X,myrank) private(j,Sz,isite1,tmp_v02, tmp_list1)
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) tmp_v02[istate] = conj(tmp_v0[j][istate]) * tmp_v0[j][istate];
    Sz = 0.0;
    tmp_list1 = list_1[j];
    for (isite1 = 1; isite1 <= X->Def.NsiteMPI; isite1++) {
      //prefactor 0.5 is added later.
      if (isite1 > X->Def.Nsite) {
        Sz += GetLocal2Sz(isite1, myrank, X->Def.SiteToBit, X->Def.Tpow);
      }
      else {
        Sz += GetLocal2Sz(isite1, tmp_list1, X->Def.SiteToBit, X->Def.Tpow);
      }
    }
    for (istate = 0; istate < nstate; istate++) {
      X->Phys.Sz[istate] += tmp_v02[istate] * Sz;
      X->Phys.Sz2[istate] += tmp_v02[istate] * Sz * Sz;
    }
  }
  SumMPI_dv(nstate, X->Phys.Sz);
  SumMPI_dv(nstate, X->Phys.Sz2);

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.doublon[istate] = 0.0;
    X->Phys.doublon2[istate] = 0.0;
    X->Phys.num[istate] = X->Def.NsiteMPI;
    X->Phys.num2[istate] = X->Def.NsiteMPI*X->Def.NsiteMPI;
    X->Phys.Sz[istate] *= 0.5;
    X->Phys.Sz2[istate] *= 0.25;
    X->Phys.num_up[istate] = 0.5*(X->Phys.num[istate] + X->Phys.Sz[istate]);
    X->Phys.num_down[istate] = 0.5*(X->Phys.num[istate] - X->Phys.Sz[istate]);
  }

  free_d_1d_allocate(tmp_v02);
  return 0;
}
/**
 * @brief Parent function to calculate expected values of energy and physical quantities.
 *
 * @param X [in,out] X Struct to get information about file header names, dimension of hirbert space, calc type, physical quantities.
 *
 * @author Takahiro Misawa (The University of Tokyo)
 * @author Kazuyoshi Yoshimi (The University of Tokyo)
 * \retval 0 normally finished.
 * \retval -1 abnormally finished.
 */
int expec_energy_flct(
  struct BindStruct *X,
  int nstate,
  double complex **tmp_v0,
  double complex **tmp_v1
) {

  long unsigned int i, j;
  long unsigned int irght, ilft, ihfbit;
  double complex dam_pr, dam_pr1;
  long unsigned int i_max;
  int istate;

  switch (X->Def.iCalcType) {
  case TPQCalc:
  case TimeEvolution:
#ifdef _DEBUG
    fprintf(stdoutMPI, "%s", cLogExpecEnergyStart);
    TimeKeeperWithStep(X, cFileNameTimeKeep, cTPQExpecStart, "a", step_i);
#endif
    break;
  case FullDiag:
  case CG:
    break;
  default:
    return -1;
  }

  i_max = X->Check.idim_max;
  if (GetSplitBitByModel(X->Def.Nsite, X->Def.iCalcModel, &irght, &ilft, &ihfbit) != 0) {
    return -1;
  }

  X->Large.i_max = i_max;
  X->Large.irght = irght;
  X->Large.ilft = ilft;
  X->Large.ihfbit = ihfbit;
  X->Large.mode = M_ENERGY;
  for (istate = 0; istate < nstate; istate++) X->Phys.energy[istate] = 0.0;

  int nCalcFlct;
  if (X->Def.iCalcType == TPQCalc) {
    nCalcFlct = 3201;
  }
  else {//For FullDiag
    nCalcFlct = 5301;
  }
  StartTimer(nCalcFlct);

  switch (X->Def.iCalcModel) {
  case HubbardGC:
    expec_energy_flct_HubbardGC(X, nstate, tmp_v0);
    break;
  case KondoGC:
  case Hubbard:
  case Kondo:
    expec_energy_flct_Hubbard(X, nstate, tmp_v0);
    break;

  case SpinGC:
    if (X->Def.iFlgGeneralSpin == FALSE) {
      expec_energy_flct_HalfSpinGC(X, nstate, tmp_v0);
    }
    else {//for generalspin
      expec_energy_flct_GeneralSpinGC(X, nstate, tmp_v0);
    }
    break;/*case SpinGC*/
    /* SpinGCBoost */
  case Spin:
    /*
    if(X->Def.iFlgGeneralSpin == FALSE){
      expec_energy_flct_HalfSpin(X);
    }
    else{
      expec_energy_flct_GeneralSpin(X);
    }
     */
    for (istate = 0; istate < nstate; istate++) {
      X->Phys.doublon[istate] = 0.0;
      X->Phys.doublon2[istate] = 0.0;
      X->Phys.num[istate] = X->Def.NsiteMPI;
      X->Phys.num2[istate] = X->Def.NsiteMPI*X->Def.NsiteMPI;
      X->Phys.Sz[istate] = 0.5 * (double)X->Def.Total2SzMPI;
      X->Phys.Sz2[istate] = X->Phys.Sz[istate] * X->Phys.Sz[istate];
    }
    break;
  default:
    return -1;
  }

  StopTimer(nCalcFlct);

#pragma omp parallel for default(none) private(i) shared(v1,v0) firstprivate(i_max)
  for (i = 1; i <= i_max; i++) {
    for (istate = 0; istate < nstate; istate++) {
      tmp_v1[i][istate] = tmp_v0[i][istate];
      tmp_v0[i][istate] = 0.0;
    }
  }

  int nCalcExpec;
  if (X->Def.iCalcType == TPQCalc) {
    nCalcExpec = 3202;
  }
  else {//For FullDiag
    nCalcExpec = 5302;
  }
  StartTimer(nCalcExpec);
  mltply(X, nstate, tmp_v0, tmp_v1); // v0+=H*v1
  StopTimer(nCalcExpec);
  /* switch -> SpinGCBoost */

  for (istate = 0; istate < nstate; istate++) {
    X->Phys.energy[istate] = 0.0;
    X->Phys.var[istate] = 0.0;
  }
#pragma omp parallel for default(none) reduction(+:dam_pr, dam_pr1) private(j) shared(v0, v1)firstprivate(i_max) 
  for (j = 1; j <= i_max; j++) {
    for (istate = 0; istate < nstate; istate++) {
      X->Phys.energy[istate] += conj(tmp_v1[j][istate])*tmp_v0[j][istate]; // E   = <v1|H|v1>=<v1|v0>
      X->Phys.var[istate] += conj(tmp_v0[j][istate])*tmp_v0[j][istate]; // E^2 = <v1|H*H|v1>=<v0|v0>
    }
  }
  SumMPI_dv(nstate, X->Phys.energy);
  SumMPI_dv(nstate, X->Phys.var);

  switch (X->Def.iCalcType) {
  case TPQCalc:
  case TimeEvolution:
#ifdef _DEBUG
    fprintf(stdoutMPI, "%s", cLogExpecEnergyEnd);
    TimeKeeperWithStep(X, cFileNameTimeKeep, cTPQExpecEnd, "a", step_i);
#endif
    break;
  default:
    break;
  }
  return 0;
}
