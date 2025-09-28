


typedef struct short_type {
        short   type;
        int     length;
        short   *vector_P;
} shortVector_t, *shortVector_Pt;

typedef struct short_vector {
        short   type;
} short_t, *short_Pt;

typedef struct byte_vector {
        short   type;
        int     length;
        unsigned char   *vector_P;
} byteVector_t, *byteVector_Pt;

typedef struct double_vector {
        short   type;
	short   transpose;
        int     length;
        double   *vector_P;
} doubleVector_t, *doubleVector_Pt;

#define OUTVEC(BUFFER_NO,DELAY) \
	 *(doubleVector_t *)BufferAccess(star_P->outBuffer_P[BUFFER_NO],0,DELAY)
	 
#define INVEC(BUFFER_NO,DELAY) \
	 *(doubleVector_t *)BufferAccess(star_P->inBuffer_P[BUFFER_NO],1,DELAY)
	 
	 