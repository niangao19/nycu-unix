#include <stdio.h>


void QuickSort(long *arr, int size ){
    if ( size > 1) {
        int end = size-1;
        long pivot = arr[end];
        int i =  -1;
        long temp;
        for (int j = 0; j < end; j++) {
            if ( arr[j] <= pivot ) {
                i++;
                temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        i++;
        arr[end] = arr[i];
        arr[i] = pivot;
        QuickSort( arr, i );
        QuickSort( arr+i+1, end - i);
    }
}

void PrintArray(long *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf( "%ld " , arr[i]);
    }
    printf("\n");
} 

int main() {


    long arr[] = { 26 ,9, 4, 1, 6, 7, 3, 8, 2, 5 , 8430};
    int n = sizeof(arr) / sizeof(long);

    printf("num:  %d original:\n" , n);
    PrintArray(arr, n);

    QuickSort(arr, n);
    // QuickSort(arr, 0, n-1);

    printf("sorted:\n");
    PrintArray(arr, n);
    return 0;
}