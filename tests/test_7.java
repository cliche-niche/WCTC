public class test_7 {
    static int binarySearch(int[] arr, int x, int size) {
        int low = 0;
        int high = size - 1;
        while (low <= high) {
            int mid = (low + high) / 2;
            if (arr[mid] == x) {
                return mid;
            } else if (arr[mid] < x) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
        return -1;
    }

    public static void main(String[] args) {
        int[] arr = new int[5];

        for(int i = 0; i < 5; i++) {
            arr[i] = i+1;
        }

        int result = binarySearch(arr, 3, 5);
        System.out.println(result);

        result = binarySearch(arr, -20, 5);
        System.out.println(result);
    }
}