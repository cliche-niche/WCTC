public class QuickSort {
    static void quickSort(int[] arr, int low, int high) {
        if (low < high) {
            int pi = partition(arr, low, high);
            quickSort(arr, low, pi-1);
            quickSort(arr, pi+1, high);
        }
    }

    static int partition(int[] arr, int low, int high) {
        int pivot = arr[high];
        int i = (low - 1);
        for (int j = low; j < high; j++) {
            if (arr[j] < pivot) {
                i++;
                int temp = arr[i];
                arr[i] = arr[j];
                arr[j] = temp;
            }
        }
        int temp = arr[i+1];
        arr[i+1] = arr[high];
        arr[high] = temp;
        return i+1;
    }

    public static void main(String[] args) {
        int[] arr = new int[5];
        int a = (5 * 23 - 21) / 5 - 13;
        arr[0] = a;
        arr[1] = 1;
        arr[2] = 4;
        arr[3] = 2;
        arr[4] = 8;

        int n = 5;
        quickSort(arr, 0, n-1);
        for (int i = 0; i < n; i++) {
            System.out.println(arr[i]);
        }
    }
}
