/*
	File:		AIFF.h

	Contains:	Definition of AIFF file format componentes

	Copyright © Apple Computer, Inc. 1989-1991 
	All rights reserved

	Additions by XCAD Corp.
	Actually dont need this file since for compatability we have to
	read and write everything a byte at a time. But we started with it
	so we will live with it unless Apple complains.

	Make sure any changes in the Marker link list is reflected in iip.h

*/

#ifndef __AIFF__
#define __AIFF__

#define LONG_TYPE int

#define FVER	0x56465245
#define SSND	0x5353444e
#define COMM	0x4f434d4d
#define FORM	0x4f464d52

#define AIFFID						'AIFF'
#define	AIFCID						'AIFC'
#define FormatVersionID				'FVER'
#define CommonID					'COMM'
#define FORMID						'FORM'
#define SoundDataID					'SSND'
#define MarkerID					'MARK'
#define InstrumentID				'INST'
#define MIDIDataID					'MIDI'
#define AudioRecordingID			'AESD'
#define ApplicationSpecificID		'APPL'
#define CommentID					'COMT'
#define NameID						'NAME'
#define AuthorID					'AUTH'
#define CopyrightID					'(c) '
#define AnnotationID				'ANNO'
#define NoLooping					0
#define ForwardLooping				1
#define ForwardBackwardLooping		2

/* AIFF-C Versions */
#define AIFCVersion1				0xA2805140

/* Compression Types */
#define	NoneName					"\pnot compressed"
#define	ACE2to1Name					"\pACE 2-to-1"
#define	ACE8to3Name					"\pACE 8-to-3"
#define	MACE3to1Name				"\pMACE 3-to-1"
#define	MACE6to1Name				"\pMACE 6-to-1"

/* Compression Names */
#define	NoneType					'NONE'
#define	ACE2Type					'ACE2'
#define	ACE8Type					'ACE8'
#define	MACE3Type					'MAC3'
#define	MACE6Type					'MAC6'

typedef  unsigned LONG_TYPE				ID; 	 
typedef	 short						MarkerIdType;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
} ChunkHeader;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
ID					formType;
} ContainerChunk;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned LONG_TYPE		timestamp;
} FormatVersionChunk,*FormatVersionChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
short				numChannels;
unsigned LONG_TYPE		numSampleFrames;
short				sampleSize;
EXTENDED			sampleRate;
} CommonChunk,*CommonChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
short				numChannels;
unsigned LONG_TYPE		numSampleFrames;
short				sampleSize;
EXTENDED			sampleRate;
ID					compressionType;
char				compressionName[1];
} ExtCommonChunk,*ExtCommonChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned LONG_TYPE		offset;
unsigned LONG_TYPE		blockSize;
} SoundDataChunk, *SoundDataChunkPtr;

typedef struct
{
MarkerIdType			id;
unsigned LONG_TYPE		position;
Str255				markerName;
} Marker;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned short		numMarkers;
Marker				Markers[1];
} MarkerChunk, *MarkerChunkPtr;

typedef struct
{
short				playMode;
MarkerIdType		beginLoop;
MarkerIdType		endLoop;
} AIFFLoop;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
char				baseFrequency;
char				detune;
char				lowFrequency;
char				highFrequency;
char				lowVelocity;
char				highVelocity;
short				gain;
AIFFLoop			sustainLoop;
AIFFLoop			releaseLoop;
} InstrumentChunk, *InstrumentChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned char		MIDIdata[1];
} MIDIDataChunk, *MIDIDataChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned char		AESChannelStatus[24];
} AudioRecordingChunk, *AudioRecordingChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
OSType				applicationSignature;
char				data[1];
} ApplicationSpecificChunk, *ApplicationSpecificChunkPtr;

typedef struct
{
unsigned LONG_TYPE		timeStamp;
MarkerIdType		marker;
unsigned short		count;
char				text[1];
} Comment;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
unsigned short		numComments;
Comment				comments[1];
} CommentsChunk, *CommentsChunkPtr;

typedef struct
{
ID					ckID;
LONG_TYPE				ckSize;
char				text[1];
} TextChunk, *TextChunkPtr;


#endif

/*
 * Markers linked list
 * XCAD Corporation
 */
typedef struct marker_object {
    unsigned LONG_TYPE 	position;
    char		name[256]; 	/* note that this is a C string */
    MarkerIdType	id;
    struct marker_object   *next_P;        /* ptr to next entry.           */
} iip_Marker_t, *iip_Marker_Pt;

/*
 *  Header for marker linked  list.
 */
typedef struct {
    int                 num;            /* number of objects            */
    int                 id;                /* Id of object */
    iip_Marker_t        *head_P;        /* head of the list */
    iip_Marker_t        *tail_P;        /* tail of the list */
} iip_MarkerHdr_t,*iip_MarkerHdr_Pt;


extern iip_MarkerHdr_Pt IIPCreateMarkerHeader();
extern  iip_Marker_Pt IIPMarkerGet();
