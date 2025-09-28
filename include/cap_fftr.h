#ifndef CAP_FTR_H
#define CAP_FTR_H

#include "cap_fft.h"
#ifdef __cplusplus
extern "C" {
#endif

    
/* 
 
 Real optimized version can save about 45% cpu time vs. complex fft of a real seq.

 
 
 */

typedef struct cap_fftr_state *cap_fftr_cfg;


cap_fftr_cfg cap_fftr_alloc(int nfft,int inverse_fft,void * mem, size_t * lenmem);
/*
 nfft must be even

 If you don't care to allocate space, use mem = lenmem = NULL 
*/


void cap_fftr(cap_fftr_cfg cfg,const cap_fft_scalar *timedata,cap_fft_cpx *freqdata);
/*
 input timedata has nfft scalar points
 output freqdata has nfft/2+1 complex points
*/

void cap_fftri(cap_fftr_cfg cfg,const cap_fft_cpx *freqdata,cap_fft_scalar *timedata);
/*
 input freqdata has  nfft/2+1 complex points
 output timedata has nfft scalar points
*/

#define cap_fftr_free free


void cmultfftcap(cap_fft_cpx *arr1, cap_fft_cpx *arr2, int length, float conj);


#ifdef __cplusplus
}
#endif
#endif
