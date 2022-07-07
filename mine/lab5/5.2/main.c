#define _CRT_SECURE_NO_WARNINGS
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#define len 10000000 //内存拷贝长度为 60000000
char src[len], dst[len]; //源地址与目的地址
int len1 = len;
extern void __stdcall memorycopy(char* dst, char* src, int len1); //声明外部函数

int main()
{
	clock_t t;
	int i, j;
	//为初始地址段赋值，以便后续从该地址段读取数据拷贝
	for (i = 0; i < len - 1; i++)
	{
		src[i] = 'a';
	}
	src[i] = 0;
	t = clock();
	memorycopy(dst, src, len1); //汇编调用，执行相应代码段。
	t = clock() - t;
	//得出目标代码段的执行时间。
	printf("memorycopy time is %11u s\n", t);
	return 0;
}