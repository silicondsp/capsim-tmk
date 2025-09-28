


#define MAX_NUMBER_OF_PARAMETERS 40
#define MAX_LINE_BUFFER_SIZE 100

typedef struct {
   char name[80];
   char value[80];
} nameValue_t, *nameValue_P;



#define MAX_ENTRIES 10000




typedef struct {
    char *name;
    char *val;
} entry;

entry*  nvp(char *buffer, int *m) ;

extern char *GetValue(char *name);
char *makeword(char *line, char stop);
char *fmakeword(char *f, char stop, int *len, int *index);
char x2c(char *what);
void unescape_url(char *url);
void plustospace(char *str);

int ReadParameters(char * fileName);
char *getValues(entry *entries,int m,char *name) ;

extern nameValue_t params_A[MAX_NUMBER_OF_PARAMETERS];
extern int paramCount;



