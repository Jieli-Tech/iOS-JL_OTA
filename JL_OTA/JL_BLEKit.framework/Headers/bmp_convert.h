



#ifndef __BMP_CONVERT_H__
 #define __BMP_CONVERT_H__


typedef unsigned char u8;
typedef char s8;
typedef unsigned short u16;
typedef short s16;
typedef unsigned int u32;
typedef int s32;

#define LWORD(buf,pos)   *((u16*)&buf[pos])
#define LDWORD(buf,pos)  *((u32*)&buf[pos])
#define NULL ((void *)0)
#define __INT_MAX 2147483647
#define RGB565(r,g,b)   ((u16)(((u16)(r)<<8)&0xF800) | (((u16)(g)<<3) & 0x07E0) | ((u16)(b)>>3))
#define REPEAT_THRESHOLD 3

int bmp_to_res(u8 *inbuf, u32 inWidth, u32 inHeight, u8 *outbuf, u32 outsize);

int btm_to_res_path(char *infile, int width, int height, char *outfile);

#endif
