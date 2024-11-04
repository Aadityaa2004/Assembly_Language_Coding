/* main.c simple program to test assembler program */

#include <stdio.h>

extern void isPrimeAssembly(unsigned long long a[], unsigned long long prime[], unsigned long long composite[], unsigned long long len);

unsigned long long isPrime(unsigned long long n)
{
	unsigned long long i;
	//prime test. if d is 1, number is prime. if d is 0, number is composite
	for(i=2; i <= n/2; ++i)
	{
		if(n % i == 0)
		{
			return 0;
		}
	}
	return 1;

}

void primeIterator(unsigned long long a[], unsigned long long prime[], unsigned long long composite[], unsigned long long len){
	unsigned long long i = 0, j = 0, k = 0; //array indices
	unsigned long long d = 0; //will be a one or zero. Was it prime or composite?
	unsigned long long temp = 0; //holds one element of the test array

	//iterate over elements of a, checking if each is prime
	for( i = 0; i < len; i++) {
		//initialize current element of a we are operating on
		d = isPrime(a[i]);


		if(d == 1){
			prime[j] = a[i];
			j++;
		}
		else{
			composite[k] = a[i];
			k++;
		}
	}
	return;

}


int main(){
	//initialize test and result arrays
	unsigned long long arrayLength = 16;
	unsigned long long a[] = {7, 16, 23, 40, 11, 39, 37, 10, 2, 18, 44, 83, 87, 5, 6, 11};
	unsigned long long prime[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	unsigned long long composite[] = {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};


	primeIterator(a, prime, composite, arrayLength);
	//isPrimeAssembly(a, prime, composite, arrayLength);

	printf("Input Array elements were: ");
	for(int i = 0; i < arrayLength; i++)
	{
		printf("%d ", a[i]);
	}
	printf("\n");

	printf("Prime Array elements are: ");
	for(int i = 0; i < arrayLength; i++)
	{
		printf("%d ", prime[i]);
	}
	printf("\n");

	printf("Composite Array elements are: ");
	for(int i = 0; i < arrayLength; i++)
	{
		printf("%d ", composite[i]);
	}
	printf("\n");
	return 0;
}

