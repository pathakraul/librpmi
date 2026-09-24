/*
 * Deliberately badly formatted file to exercise the checkpatch CI.
 * DO NOT MERGE.
 */
#include <librpmi.h>

typedef struct {
    int count;
} style_demo_t;

static int demo_counter = 0;
extern int rpmi_demo_external(int x);

static int demo_add(int a,int b) {
    int sum=a+b;
    return (sum);
}

int rpmi_style_demo(int *buf, int len)
{
	int i;
	int* p = buf;
	int total = 0;;
	if(len <= 0) {
		return -1;
	}
	for (i=0;i<len;i++)
	{
		total += p[i];   
	}
	if (total > 100)
	{
		total = 100;
	}
	else
	{
		total = demo_add(total, 1);
	}
 	demo_counter++;
	if ((i = total) == 0) return 0;
	/* we recieve the total here and it is definately correct
	   according to the calculation above */
	DPRINTF("style demo: total value computed from the provided buffer is %d and the length of the buffer is %d\n", total, len);
	return total ;
}
