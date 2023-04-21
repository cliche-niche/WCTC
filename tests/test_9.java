public class test_9 {
    static void bubbleSort(int[] arr, int size) {
        int n = size;
        for (int i = 0; i < n-1; i++) {
            for (int j = 0; j < n-i-1; j++) {
                if (arr[j] > arr[j+1]) {
                    int temp = arr[j];
                    arr[j] = arr[j+1];
                    arr[j+1] = temp;
                }
            }
        }
        return;
    }

    public static void main(String[] args) {
        int[] arr = new int[9];
        arr[0] = 5;
        arr[1] = 1;
        arr[2] = 4;
        arr[3] = 2;
        arr[4] = 8;
        arr[5] = 20;
        arr[6] = -2;
        arr[7] = 102;
        arr[8] = 78;

        bubbleSort(arr, 9);

        for (int i = 0; i < 9; i++) {
            System.out.println(arr[i]);
        }
    }
}